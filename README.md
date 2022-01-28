Penetrating Testing/Assessment Workflow & other fun infosec stuff

https://github.com/jivoi/pentest

My feeble attempt to organize (in a somewhat logical fashion) the vast amount of information, tools, resources, tip and tricks surrounding penetration testing, vulnerability assessment, and information security as a whole*

- Reconnaissance
  - Passive/Semi-Passive
    - Tools
      - Discover - https://github.com/leebaird/discover
    - Third Party Resources
      - Locate Target Range
        - ARIN - https://www.arin.net/
      - Fingerprint Domain/Website
        - Extended Network Information
          - Central Ops - https://centralops.net/co/DomainDossier.aspx
          - Robtex - https://www.robtex.net/
        - Metasploit Scanning
          - auxiliary/scanner/*
            - portscan/tcp
            - http/http_version
            - http/tomcat_enum
            - http/trace_axd
            - Google - site:<result from above> filetype:axd OR inurl:trace.axd
        - Shodan - https://www.shodan.io/
          - https://pen-testing.sans.org/blog/2015/12/08/effective-shodan-searches/
        - Censys - https://www.censys.io/
        - Zoomeye - https://www.zoomeye.org
        - Netcraft - https://www.netcraft.com/
        - DNS Enumeration/Information
          - DNSdumpster - https://dnsdumpster.com/
          - Subli3ster - https://github.com/aboul3la/Sublist3r
      - Social Media 
        - https://socialbearing.com/search/
    - Command Line Recon
      - Network Information
        - nslookup <target>
        - dig <target>
      - Security Mechanisms
        - Halberd - Identify HTTP load balancers 
          - https://github.com//jmbr/halberd
      - Metadata
        - exiftool
        - strings
          - strings -e b (big endian) OR -e l (little endian)
        - Just-Metadata
          - https://github.com/ChrisTruncer/Just-Metadata
    - People Search
      - Yahoo People Search - http://itools.com/tool/yahoo-people-search
      - Switchboard - http://www.switchboard.com/person
      - Google Finance - https://www.google.com/finance
      - Zaba - http://www.zabasearch.com/
  - Active
    - Command Line Recon Tools
      - General Recon
        - Recon-NG - https://bitbucket.org/LaNMaSteR53/recon-ng
          - Automated with https://github.com/jhaddix/domain
        - Domain/Subdomain Enumeration/Information
          - Fierce - https://github.com/mschwager/fierce
          - Subli3ster - https://github.com/aboul3la/Sublist3r
          - EyeWitness - https://github.com/ChrisTruncer/EyeWitness
          - Altdns - https://github.com/infosec-au/altdns
          - Brute force subdomain list - https://github.com/danielmiessler/SecLists/blob/master/Discovery/DNS/sorted_knock_dnsrecon_fierce_recon-ng.txt
      - Nmap
        - nmap -Pn -sSU -sV --top-ports 20 <target>
      - Create Custom Worldlist
        - cewl - https://digi.ninja/projects/cewl.php
        - wget - http://wiki.securityweekly.com/wiki/index.php/Episode129
      - Tools
        - WPS (Wi-Fi) Information Gathering
          - https://www.coresecurity.com/corelabs-research/open-source-tools/wpsig
        - Viper - Automating Various Pentesting Tasks
          - https://github.com/chrismaddalena/viper
        - pyFOCA - Python version of FOCA
          - https://github.com/altjx/ipwn#user-content-pyfoca
        - truffleHog - https://github.com/dxa4481/truffleHog
        - Discover - https://github.com/leebaird/discover
    - GUI
      - FOCA - https://www.elevenpaths.com/labstools/foca/index.html
        - EvilFOCA - https://github.com/ElevenPaths/EvilFOCA
      - Maltego - http://sectools.org/tool/maltego/
      - Dirbuster - http://sectools.org/tool/dirbuster/
  - Google Searching
    - site:"target name" jobs,careers,openings,etc
    - intitle:"index of <Keyword>"
      - Keyword
        - .bash_history
        - etc/shadow
        - finances.xls(x)
        - htpasswd
        - inurl:maillog
    - site:*.edu filetype:*.bak OR <keyword>
      - Keyword
        - *.conf
        - *.backup
  - Phishing 
    - Important: Immediately pivot from initial host
    - Frameworks
      - Gophish - https://github.com/gophish/gophish
      - Phishing Frenzy - https://www.phishingfrenzy.com/
      - King Phisher - https://github.com/securestate/king-phisher
      - FiercePhish - https://github.com/Raikia/FiercePhish
      - Empire - https://enigma0x3.net/2016/03/15/phishing-with-empire/
    - Initial Access Techniques
      - Malicious Office XLS macros
        - https://www.shellntel.com/blog/2016/9/13/luckystrike-a-database-backed-evil-macro-generator
    - Tools for Internal Use
      - Basic AUTH credential harvesting - https://github.com/ryhanson/phishery
- Enumeration
  - Internal
    - Scanning
      - Map Internal Network
        - Command Line Tools
          - arp -a
          - ip neigh show
          - smbtree -NS 2>/dev/null
          - nbtscan -r <current_IPrange>
          - netdiscover -r <current_IPrange>
          - nmap -n -Pn -T5 -sS <current_IPrange>
            - nmap NSE scripts
              - NFS
              - SMB
        - SMB
          - SMBSpider - https://github.com/altjx/ipwn#user-content-smbspider
          - More - https://pen-testing.sans.org/blog/2013/07/24/plundering-windows-account-info-via-authenticated-smb-sessions
        - Find Routers - https://github.com/pentestmonkey/gateway-finder
    - Pivoting
      - SSH Proxy Tunneling with Proxychain
        - http://magikh0e.ihtb.org/pubPapers/ssh_gymnastics_tunneling.html
  - External
    - Scanning
      - Nmap
      - Masscan - https://github.com/robertdavidgraham/masscan
      - Unicornscan - http://sectools.org/tool/unicornscan/
      - OneTwoPunch
        - Combines nmap and unicorn scan https://github.com/superkojiman/onetwopunch/blob/master/onetwopunch.sh
- Exploitation
  - External
    - Attack Windows
      - Full Guides
        - http://resources.infosecinstitute.com/wp-content/uploads/Network-Fingerprinting-and-Exploitation1.pdf
    - Attack Linux
      - Full Guides
        - http://resources.infosecinstitute.com/wp-content/uploads/Network-Fingerprinting-and-Exploitation1.pdf
    - Attack Web Applications
      - Full Attack Frameworks
        - Offensive Web Testing Framework - https://owtf.github.io/
        - Web2attack - https://github.com/santatic/web2attack
        - EaST - Exploits And Security Tool Framework
          - https://github.com/C0reL0ader/EaST
        - Attack WAF
          - WAFNinja - https://github.com/khalilbijjou/WAFNinja
          - My Guide: http://pastebin.com/bUrGCYxE
      - Steal HTTP/S Session Cookies
        - https://github.com/EnableSecurity/surfjack
      - XSS Scanner
        - xsscrapy - https://github.com/DanMcInerney/xsscrapy
      - XSS/Bypass Techniques
        - Beat XSS Filters
          - http://brutelogic.com.br/blog/the-easiest-way-to-bypass-xss-mitigations/
        - XSS Cheatsheet
          - http://brutelogic.com.br/blog/cheat-sheet/
      - WAF Bypass
        - http://securityidiots.com/Web-Pentest/WAF-Bypass/waf-bypass-guide-part-1.html
      - Attack BASIC Auth
        - Burp - http://www.smeegesec.com/2012/02/attacking-basic-authentication-with.html
        - Ncrack (supports multiple protocols) - https://nmap.org/ncrack/
      - Methodologies - https://blog.zsec.uk/ltr101-methodologies/
    - Attack OWA/Exchange
      - Malicious Outlook Rules - https://silentbreaksecurity.com/malicious-outlook-rules/
      - Ruler - Abuse Exchange services - https://github.com/sensepost/ruler
      - MailSniper - Search users mailbox - http://www.blackhillsinfosec.com/?p=5296
    - Web Vulnerability Scanners
      - Burp - https://portswigger.net/burp/
        - Author's Guide: http://pastebin.com/nNHYP9Jd
      - Wapiti http://wapiti.sourceforge.net/
      - w3af - http://w3af.org/
      - Nikto -https://cirt.net/Nikto2
    - Command Line Tools
      - CMSmap
        - https://github.com/Dionach/CMSmap
      - WPscan
        - https://wpscan.org/
      - Joomscan
        - https://www.owasp.org/index.php/Category:OWASP_Joomla_Vulnerability_Scanner_Project
    - Wireless Exploitation
      - AirVentriloquest - Aircrack patch for WPA/2 packet injection
        -  https://github.com/Caesurus/airventriloquist
      - Fluxion - MiTM WPA/2 Networks
        - https://github.com/deltaxflux/fluxion
  - Internal 
    - LAN Attacks
      - Attack Windows
        - Attack Active Directory 
          - Blood Hound - https://github.com/adaptivethreat/BloodHound
          - CrackMapExec - https://github.com/byt3bl33d3r/CrackMapExec
          - EmPyre - http://www.rvrsh3ll.net/blog/empyre/empyre-engaging-active-directory/
          - Red Teaming AD (PDF) 
            - https://adsecurity.org/wp-content/uploads/2016/08/DEFCON24-2016-Metcalf-BeyondTheMCSE-RedTeamingActiveDirectory.pdf
        - Attack SQL Server
          - PowerUpSQL - https://github.com/NetSPI/PowerUpSQL
        - Python
          - Command Line (Python Interpreter)
            - Scapy advanced network attacks 
              - https://packetstormsecurity.com/files/36839/blackmagic.txt.html
            - Local Python Server 
              - Serve Shells/Exploits
                - Python -M SimpleHTTPServer <port>
            - Python TTY Reverse Shell IPv6
              - https://eelsivart.blogspot.com/2015/02/python-tty-reverse-shell-over-ipv6-one.html
            - Metasploit In-Memory Python Interpreter 
              - https://github.com/rapid7/metasploit-framework/wiki/Python-Extension
        - Attack Tools
          - Responder - https://github.com/SpiderLabs/Responder
          - Impacket - https://github.com/CoreSecurity/impacket
          - SMBExec - https://github.com/pentestgeek/smbexec
          - SMBSpider - https://github.com/altjx/ipwn#user-content-smbspider
          - Basic AUTH credential harvesting - https://github.com/ryhanson/phishery
          - WCE - http://www.ampliasecurity.com/research/windows-credentials-editor/
          - Metasploit In-Memory Python Interpreter 
            - https://github.com/rapid7/metasploit-framework/wiki/Python-Extension
          - Packet Crafting 
            - Scapy
              - https://thesprawl.org/research/scapy/
            - Impacket
              - https://www.coresecurity.com/corelabs-research/open-source-tools/impacket
        - Powershell
          - PowerSploit - https://github.com/PowerShellMafia/PowerSploit
            - More - https://www.hackingloops.com/powersploit-quick-shell-for-penetration-testing/
          - EmPyre - http://www.rvrsh3ll.net/blog/empyre/empyre-engaging-active-directory/
          - Bypass UAC -  https://github.com/FuzzySecurity/PowerShell-Suite/tree/master/Bypass-UAC
        - PsExec
          - http://techgenix.com/PsExec-Nasty-Things-It-Can-Do/
      - Privilege Escalation
        - Windows
          - NTLM Relay/NBNS Spoofing - https://foxglovesecurity.com/2016/01/16/hot-potato/
        - Linux/Unix  
          - Various exploits - https://github.com/FuzzySecurity/Unix-PrivEsc
          - LinEnum- https://github.com/rebootuser/LinEnum
          - Unix-privesc-check - http://pentestmonkey.net/tools/audit/unix-privesc-check
          - Priv Esc/Enumeration - https://www.rebootuser.com/?p=1623
          - Linux_Exploit_Suggester - https://github.com/PenturaLabs/Linux_Exploit_Suggester
    - Bypass AV/IDS/App Whitelisting/UAC
      - Egressing Bluecoat with CobaltStrike
        -  https://cybersyndicates.com/2016/12/egressing-bluecoat-with-cobaltstike-letsencrypt/
      - Beaconpire
        - https://bluescreenofjeff.com/2016-11-29-beaconpire-cobalt-strike-and-empire-interoperability-with-aggressor-script/
      - Bypass App Whitelisting
        - https://enigma0x3.net/2016/11/21/bypassing-application-whitelisting-by-using-rcsi-exe/
      - "Fileless" UAC Bypass
        - https://enigma0x3.net/2016/08/15/fileless-uac-bypass-using-eventvwr-exe-and-registry-hijacking/
      - Download/Execute Code via Command Line
        - https://www.greyhathacker.net/?p=500
    - Reverse Shells
      - http://bernardodamele.blogspot.com/2011/09/reverse-shells-one-liners.html
      - http://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet
      - https://highon.coffee/blog/reverse-shell-cheat-sheet/
    - Attack Routers
      - Router Exploitation Framework - https://github.com/reverse-shell/routersploit
      - Using Burp - https://www.cybrary.it/0p3n/pentesting-routers-1-dictionary-attack-burp-suite/
  - Find Exploits
    - Web
      - Exploit-db - https://www.exploit-db.com/
        - From command line: https://www.exploit-db.com/searchsploit/
      - Packet Storm - https://packetstormsecurity.com/files/tags/exploit
      - SecurityFocus - http://www.securityfocus.com/bid
      - EaST Framework Exploits - http://eastexploits.com/
      - SecList - http://seclist.us/category/exploits
    - NMap
      - Scan systems with NMap, parse output to: CVE's, CWE's and DPE's
        - https://github.com/NorthernSec/CVE-Scan
      - Import, manage, and search with a local MongoDB instance
        -  https://github.com/cve-search/cve-search
- Post-Exploitation
  - Attack Linux
    - Command Line Password Sniffing
      - Tcpdump
        -  https://neverendingsecurity.wordpress.com/2015/03/14/tcpdump-tutorial-sniffing-and-analysing-packets-from-the-commandline/
        - tcpdump -i eth0 port http or port ftp or port smtp or port imap or port pop3 -l -A | egrep –i 'pass=|pwd=|log=|login=|user=|username=|pw=|passw=|passwd=|password=||name=|name:|pass:|user:|username:|password:|login:|pass |user ' --color=auto --line-
      - Ngrep
        - ngrep -q -W byline "GET|POST HTTP"
      - Dsniff - https://github.com/tecknicaltom/dsniff
      - Netsh Trace (Windows only) - https://isc.sans.edu/diary/19409
      - Network Authentication Cracking Tool - https://nmap.org/ncrack/
  - Attack Windows
    - Stealing/Cracking Passwords/Hashes 
      - Steal
        - WCE -http://www.ampliasecurity.com/research/windows-credentials-editor/
        - Extract Hashes from AD - https://blog.didierstevens.com/2016/07/13/
        - Network Authentication Cracking Tool - https://nmap.org/ncrack/
        - pysecdump - https://github.com/pentestmonkey/pysecdump
        - Windows Creds - https://www.securusglobal.com/community/2013/12/20/dumping-windows-credentials/
        - Network Password Recovery - http://www.nirsoft.net/utils/network_password_recovery.html
      - Crack
        - Windows Password Audit - https://blog.joelj.org/windows-password-audit-with-kali-linux/
        - pysecdump - https://blog.didierstevens.com/2016/07/30/video-ntds-dit-extract-hashes-with-secretsdump-py/
        - Hashcat - https://samsclass.info/123/proj10/px16-hashcat-win.htm
        - Network Authentication Cracking Tool - https://nmap.org/ncrack/
  - Attack Mac
    - Empyre 
      - http://www.harmj0y.net/blog/empyre/building-an-empyre-with-python/
  - Attack Specific Software/Tools
    - Privilege Escalation
      - Splunk
        - http://threat.tevora.com/penetration-testing-with-splunk-leveraging-splunk-admin-credentials-to-own-the-enterprise/
  - Password/Hash Cracking 
    - Wordlists
      - https://github.com/Mebus/cupp
      - http://wiki.securityweekly.com/wiki/index.php/Episode129
      - https://adaywithtape.blogspot.com.au/2011/05/creating-wordlists-with-crunch-v30.html
      - https://wiki.skullsecurity.org/Passwords
    - Password/Hash Cracking
      - Guides
        - Build Cracking Rig
          - http://www.netmux.com/blog/how-to-build-a-password-cracking-rig
        - Cracking 12 Character Passwords
          - http://www.netmux.com/blog/cracking-12-character-above-passwords
      - Tools
        - PACK (crack/obtain stats/) - https://thesprawl.org/projects/pack/
        - Hashcat - https://hashcat.net/hashcat/
          -  https://samsclass.info/123/proj10/px16-hashcat-win.htm
        - Windows Password Audit - https://blog.joelj.org/windows-password-audit-with-kali-linux/
        - pysecdump - https://blog.didierstevens.com/2016/07/30/video-ntds-dit-extract-hashes-with-secretsdump-py/
        - GPU Cracking
          - https://www.trustedsec.com/june-2016/introduction-gpu-password-cracking-owning-linkedin-password-dump/
      - Web Services 
        - CrackStation - https://crackstation.net/
        - HashKiller - https://forum.hashkiller.co.uk/default.aspx
  - Attack Frameworks/Tools 
    - PowerSploit - https://github.com/PowerShellMafia/PowerSploit
    - Empire - http://www.powershellempire.com/
    - Armitage - http://www.fastandeasyhacking.com/manual
      - http://blog.cobaltstrike.com/2016/05/25/raffis-abridged-guide-to-cobalt-strike/
    - Pwnd(dot)sh - https://github.com/SafeBreach-Labs/pwndsh
    - CrackMapExec
      - https://github.com/byt3bl33d3r/CrackMapExec/wiki
  - Privilege Escalation - Excellent Wiki - http://pwnwiki.io/#!index.md
    - Windows
      - Wiki - http://pwnwiki.io/#!privesc/windows/index.md
      - SMB
        - Relay Attacks/Spoofing
          - Hot Potato - https://foxglovesecurity.com/2016/01/16/hot-potato/
          - Chuckle 
            - https://www.nccgroup.trust/uk/about-us/newsroom-and-events/blogs/2015/november/introducing-chuckle-and-the-importance-of-smb-signing/
          - More - https://pen-testing.sans.org/blog/2013/04/25/smb-relay-demystified-and-ntlmv2-pwnage-with-python
      - RDP 
        - https://onedrive.live.com/view.aspx?resid=F32A9F4F1477E49!109&ithint=file%2cdocx&app=Word&authkey=!ANzQTrmsTXSK9FM 
      - Various techniques/commands
        - http://resources.infosecinstitute.com/wp-content/uploads/Post-Exploitation-without-Automated-Tools1.pdf
        - http://www.slideshare.net/riyazwalikar/windows-privilege-escalation
    - Linux/Unix  
      - Various exploits - https://github.com/FuzzySecurity/Unix-PrivEsc
      - Wiki - http://pwnwiki.io/#!privesc/linux/index.md
      - LinEnum- https://github.com/rebootuser/LinEnum
      - Unix-privesc-check - http://pentestmonkey.net/tools/audit/unix-privesc-check
      - Priv Esc/Enumeration - https://www.rebootuser.com/?p=1623
      - Basic Linux Privilege Escalation
        -  https://blog.g0tmi1k.com/2011/08/basic-linux-privilege-escalation/
      - Linux_Exploit_Suggester
        - https://github.com/PenturaLabs/Linux_Exploit_Suggester
      - Various techniques/commands 
        - https://room362.com/post/2011/2011-09-06-post-exploitation-command-lists/
- Exfiltration
  - Detection Capabilities
    - Egress-Assess
      - https://github.com/ChrisTruncer/Egress-Assess
    - Outbound Port Detection (find unfiltered outbound connections)
      - http://www.floyd.ch/?p=352
  - Network Exfiltration
    - DNS
      - dnsteal - https://github.com/m57/dnsteal
- Learning Resources 
  - Blogs
    - Mubix - https://room362.com/
    - OJ's Perspective - http://buffered.io/
    - Carnal0wnage - http://carnal0wnage.attackresearch.com/
    - Corelan - https://www.corelan.be/
    - Daniel Miessler https://danielmiessler.com/information-security/
    - NetSec Addict - http://netsec.ws/
    - SecList - http://seclist.us/
    - Notepad - https://bobloblaw.gitbooks.io/security/content/
  - Getting Started
    - Security 
      - http://www.pentester.tips/gettingstarted.html
      - https://bobloblaw.gitbooks.io/security/content/
      - https://www.reddit.com/r/HowToHack/comments/2c8d1p/free_online_ethical_hacking_courses/
    - Networking
      - http://networkingprogramming.com/1024x768/index.html
  - OSCP Info 
    - http://buffered.io/posts/oscp-and-me/
    - https://jivoi.github.io/2015/06/19/oscp-prepare/
    - https://gnashsec.blogspot.com/2015/07/my-experience-with-pwk-and-oscp.html
  - Video Series/Channels
    - LiveOverflow - https://www.youtube.com/channel/UClcE-kVhqyiHCcjYwcpfj9w
    - Pentestit - https://www.youtube.com/user/PentestITLab/videos
  - Hacking Labs/VMs
    - Vulnerable Windows Environment - http://www.crowdfunder.co.uk/rastalabs
    - Web Apps
      - Web Security Labs - http://www.cis.syr.edu/~wedu/seed/web_security.html
      - 40 Vulnerable Sites
        - https://www.bonkersabouttech.com/security/40-plus-list-of-intentionally-vulnerable-websites-to-practice-your-hacking-skills/392
      - DVWS - https://github.com/interference-security/DVWS
      - oxfat - https://0xf.at/
    - Find more here
      - https://skydogcon.blogspot.com/p/learning-resources.html
      - https://blogs.sans.org/pen-testing/files/2013/06/PosterSide1.png
      - http://www.amanhardikar.com/mindmaps/practice-links.html
  - Specific Topic Learning
    - Web Application Security 
      - Solid Methodology - http://blog.zsec.uk/ltr101-method-to-madness/
      - Introduction (left hand side) - http://securityidiots.com/index.html
      - XSS
        - Start here - http://brutelogic.com.br/blog/xss101/
        - Practice XSS - https://xss-game.appspot.com/level1
          - VM - https://www.vulnhub.com/entry/pentester-lab-web-for-pentester,71/
      - SQLi (SQL Injection)
        - http://attack.samsclass.info/sqlol-raw/search-raw.htm
      - Various Web Exploits - https://google-gruyere.appspot.com/part1
    - Scripting/Coding
      - Python
        - Scapy - http://thesprawl.org/research/scapy/
          -  https://bt3gl.github.io/black-hat-python-infinite-possibilities-with-the-scapy-module.html
        - Full Python Course - https://www.codecademy.com/learn/python
      - Exploit Development/Exploitation
        - Modern Binary Exploitation - https://github.com/RPISEC/MBE
        - https://www.peerlyst.com/posts/the-best-resources-for-learning-exploit-development
      - Crypto
        - https://littlemaninmyhead.wordpress.com/2015/09/28/so-you-want-to-learn-to-break-ciphers/
    - Malware Analysis/Reversing
      - Start Here - https://github.com/tylerph3/awesome-reversing
      - University Course - https://github.com/RPISEC/Malware
      - Ray's World - http://rayseyfarth.com/
      - Amanda -  http://amanda.secured.org/how-to-start-reverse-engineering-malware/
    - Practice Phishing
      - Morning Catch - http://blog.cobaltstrike.com/2014/08/06/introducing-morning-catch-a-phishing-paradise/
  - Free University Courses
    - https://www.cs.fsu.edu/~redwood/OffensiveComputerSecurity/lectures.html
  - Challenges
    - SANS Holiday Hack Challenge - https://holidayhackchallenge.com/2016/
      - Before 2014 - https://pen-testing.sans.org/holiday-challenge/2014
    - PCAP Challenges
      - https://github.com/aeibrahim/wireshark_challenge
      - https://www.honeynet.org/challenges
  - Fun Reading List
    - http://www.moserware.com/2009/06/first-few-milliseconds-of-https.html
- Repos/Collection of Tools
  - Large Toolset - https://awesomehacking.org/
  - Large repo (many topics)
    - https://github.com/nixawk/pentest-wiki
    - https://github.com/Hack-with-Github/Awesome-Hacking
  - Penetration Testing Tools
    - Tons - https://github.com/enaqx/awesome-pentest
    - Tons - https://github.com/Aptive/penetration-testing-tools
  - Python
    - Intro - https://github.com/PacktPublishing/Python-Journey-from-Novice-to-Expert
    - Penetration Testing Tools - https://github.com/dloss/python-pentest-tools
    - Python Forensics - https://github.com/PacktPublishing/Learning-Python-for-Forensics
  - Reverse Engineering - https://github.com/tylerph3/awesome-reversing
- Complete Courses/Videos/Guides/Books
  - Existing Full Guides (fantastic!)
    - Pentest Wiki - https://github.com/nixawk/pentest-wiki
    - Awesome Pentest - https://github.com/enaqx/awesome-pentest
  - CTF 
    - Field Guide - https://trailofbits.github.io/ctf/
    - Author's Guide - http://pastebin.com/DrsetKc8
    - Resources
      - http://resources.infosecinstitute.com/tools-of-trade-and-resources-to-prepare-in-a-hacker-ctf-competition-or-challenge/
  - Attack 
    - IPv6
      - http://haxpo.nl/materials/haxpo2015ams/D3%20-%20R.%20Schaefer%20and%20J.%20Salazar%20-%20Pentesting%20in%20the%20Age%20of%20IPv6.pdf
    - Windows
      - Zero to Domain
        - http://www.computerworld.com/article/2843632/security0/scenario-based-pen-testing-from-zero-to-domain-admin-with-no-missing-patches-required.html
      - Network Fingerprinting and Exploitation - 
        - http://resources.infosecinstitute.com/wp-content/uploads/Network-Fingerprinting-and-Exploitation1.pdf
    - Linux
      - Network Fingerprinting and Exploitation - 
        - http://resources.infosecinstitute.com/wp-content/uploads/Network-Fingerprinting-and-Exploitation1.pdf
  - Courses
    - Metasploit Unleashed - https://www.offensive-security.com/metasploit-unleashed/
    - Pen Testing - https://www.cybrary.it/course/advanced-penetration-testing/
  - Videos
    - Advanced Threat Tactics 
      - http://blog.cobaltstrike.com/2015/09/30/advanced-threat-tactics-course-and-notes/
  - Books
    - Advanced Penetration Testing for Highly Secured Environments  
      - LARGE (!) PDF - https://news.asis.io/sites/default/files/%E2%80%8Cbook.pdf
    - Multiple pentesting books - http://www.arthur-training.com/Downloads/ITT/
  - How-To
    - Evil Access Point - https://www.sensepost.com/blog/2013/rogue-access-points-a-how-to/
    - DNS Phishing in Public Hotspots - https://www.exploit-db.com/docs/20875.pdf
    - Various topics - https://bobloblaw.gitbooks.io/security/content/
  - Misc. Resources
    - Lectures/VMs/Videos (tons) - http://www.arthur-training.com/Downloads/
- Cheatsheets
  - Various Pentesting Tools
    - https://highon.coffee/blog/penetration-testing-tools-cheat-sheet/
  - Powershell
    - Mics Scripts - https://github.com/rvrsh3ll/Misc-Powershell-Scripts
    - https://ramblingcookiemonster.github.io/images/Cheat-Sheets/powershell-cheat-sheet.pdf
  - Python
    - https://www.cheatography.com/davechild/cheat-sheets/python/
    - 2 - https://realpython.com/files/python_cheat_sheet_v1.pdf
    - 3 - https://perso.limsi.fr/pointal/_media/python:cours:mementopython3-english.pdf
    - Shells - http://bernardodamele.blogspot.com/2011/09/reverse-shells-one-liners.html
  - Netcat
    - https://neverendingsecurity.wordpress.com/2015/04/13/netcat-commands-cheatsheet/
    - https://www.securitaus.org/netcat/pentest/2016/05/23/netcat-cheat-sheet.html
  - Tcpdump
    - http://bencane.com/2014/10/13/quick-and-practical-reference-for-tcpdump/
    - http://packetlife.net/media/library/12/tcpdump.pdf
  - Collections of Cheatsheets 
    - https://github.com/jshaw87/Cheatsheets
    - http://packetlife.net/library/cheat-sheets/
    - http://www.danielowen.com/2017/01/01/sans-cheat-sheets/
    - SANS - https://pen-testing.sans.org/resources/downloads
- Detection/Remediation/Defending
  - Detecting Meterpreter
    - https://www.sans.org/reading-room/whitepapers/forensics/analysis-meterpreter-post-exploitation-35537
  - Detecting Backdoors
    - https://www.rawhex.com/2016/03/a-guide-to-recognising-backdoors-using-metasploitable-2/
  - Detecting Malicious VBA Macros
    - https://github.com/decalage2/oletools/wiki/mraptor
