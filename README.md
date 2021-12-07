3.9. Элементы безопасности информационных систем
   
1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.
     
	     Зарегестрировался и установил
		 https://ibb.co/939DrZ8
		 
2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.

         Включил настройки Bitwarden
		 https://ibb.co/89Z6hLQ
		 При логине появилось требование 2го фактора
		 https://ibb.co/WWFL8N8
		 
3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.

         # Устанавливаем apache2
         student@student-virtual-machine:/etc/apache2/sites-available$ sudo systemctl status apache2
         ● apache2.service - The Apache HTTP Server
              Loaded: loaded (/lib/systemd/system/apache2.service; enabled; vendor preset: enabled)
              Active: active (running) since Tue 2021-12-07 15:13:03 MSK; 27min ago
                Docs: https://httpd.apache.org/docs/2.4/
             Process: 14090 ExecReload=/usr/sbin/apachectl graceful (code=exited, status=0/SUCCESS)
            Main PID: 13373 (apache2)
               Tasks: 55 (limit: 2292)
              Memory: 5.4M
              CGroup: /system.slice/apache2.service
                      ├─13373 /usr/sbin/apache2 -k start
                      ├─14094 /usr/sbin/apache2 -k start
                      └─14095 /usr/sbin/apache2 -k start
		 
		 # Генерируем сертификат
		 student@student-virtual-machine:~$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
         Generating a RSA private key
         ....+++++
         .......................................................................................+++++
         writing new private key to '/etc/ssl/private/apache-selfsigned.key'
         -----
         You are about to be asked to enter information that will be incorporated
         into your certificate request.
         What you are about to enter is what is called a Distinguished Name or a DN.
         There are quite a few fields but you can leave some blank
         For some fields there will be a default value,
         If you enter '.', the field will be left blank.
         -----
         Country Name (2 letter code) [AU]:RU
         State or Province Name (full name) [Some-State]:SPb
         Locality Name (eg, city) []:SPb
         Organization Name (eg, company) [Internet Widgits Pty Ltd]:Student
         Organizational Unit Name (eg, section) []:Student
         Common Name (e.g. server FQDN or YOUR name) []:10.0.2.12
         Email Address []:evgenplay@inbox.ru
		 
		 # Настраиваем Apache на работы по https
         student@student-virtual-machine:~$ sudo nano /etc/apache2/conf-available/ssl-params.conf
         SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
         SSLProtocol All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
         SSLHonorCipherOrder On
         
         Header always set X-Frame-Options DENY
         Header always set X-Content-Type-Options nosniff
         
         SSLCompression off
         SSLUseStapling on
         SSLStaplingCache "shmcb:logs/stapling-cache(150000)"
     
         SSLSessionTickets Off
		 
		 student@student-virtual-machine:~$ sudo nano /etc/apache2/sites-available/default-ssl.conf
		 <IfModule mod_ssl.c>
         <VirtualHost _default_:443>
                ServerAdmin webmaster@localhost
                ServerName 10.0.2.12
                DocumentRoot /var/www/html

                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined

                SSLEngine on

                SSLCertificateFile      /etc/ssl/certs/apache-selfsigned.crt
                SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
                
				<FilesMatch "\.(cgi|shtml|phtml|php)$">
                                SSLOptions +StdEnvVars
                </FilesMatch>
                <Directory /usr/lib/cgi-bin>
                                SSLOptions +StdEnvVars
                </Directory>
         </VirtualHost>
         </IfModule>
         
		 student@student-virtual-machine:~$ sudo nano /etc/apache2/sites-available/000-default.conf
		 <VirtualHost *:80>
        
                 Redirect "/" "https://10.0.2.12/"
                 ServerAdmin webmaster@localhost
                 DocumentRoot /var/www/html

                 ErrorLog ${APACHE_LOG_DIR}/error.log
                 CustomLog ${APACHE_LOG_DIR}/access.log combined

         </VirtualHost>

         # Запускаем модули, проверяем синтаксис, и перезапускаем сервис
         student@student-virtual-machine:~$ sudo a2enmod ssl
         student@student-virtual-machine:~$ sudo a2enmod headers
         student@student-virtual-machine:~$ sudo a2ensite default-ssl
         student@student-virtual-machine:~$ sudo a2enconf ssl-params
         student@student-virtual-machine:~$ sudo apache2ctl configtest
         student@student-virtual-machine:~$ sudo systemctl restart apache2
		 
		 # Заходим на сервер и наблюдаем результат
		 https://ibb.co/Hn59SgQ
		 
4. Проверьте на TLS уязвимости произвольный сайт в интернете.
         
		 student@student-virtual-machine:~/netology/testssl.sh$ ./testssl.sh -U --sneaky https://netology.ru/

         ###########################################################
             testssl.sh       3.1dev from https://testssl.sh/dev/
             (0eb73d9 2021-12-07 08:55:54 -- )

               This program is free software. Distribution and
                      modification under GPLv2 permitted.
               USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

                Please file bugs @ https://testssl.sh/bugs/

         ###########################################################

         Using "OpenSSL 1.0.2-chacha (1.0.2k-dev)" [~183 ciphers]
         on student-virtual-machine:./bin/openssl.Linux.x86_64
         (built: "Jan 18 17:12:17 2019", platform: "linux-x86_64")


         Testing all IPv4 addresses (port 443): 172.67.21.207 104.22.40.171 104.22.41.171
         ----------------------------------------------------------------------------------------------------------------
         Start 2021-12-07 16:41:28        -->> 172.67.21.207:443 (netology.ru) <<--

         Further IP addresses:   104.22.40.171 104.22.41.171 2606:4700:10::6816:28ab 2606:4700:10::6816:29ab 2606:4700:10::ac43:15cf 
         rDNS (172.67.21.207):   --
         Service detected:       HTTP


         Testing vulnerabilities 

         Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
         CCS (CVE-2014-0224)                       not vulnerable (OK)
         Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session tickets
         ROBOT                                     not vulnerable (OK)
         Secure Renegotiation (RFC 5746)           OpenSSL handshake didn't succeed
         Secure Client-Initiated Renegotiation     not vulnerable (OK)
         CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
         BREACH (CVE-2013-3587)                    potentially NOT ok, "gzip" HTTP compression detected. - only supplied "/" tested
                                                   Can be ignored for static pages or if no secrets in the page
         POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
         TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
         SWEET32 (CVE-2016-2183, CVE-2016-6329)    VULNERABLE, uses 64 bit block ciphers
         FREAK (CVE-2015-0204)                     not vulnerable (OK)
         DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                                   make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                                   https://censys.io/ipv4?q=0E745E5E77A60345EB6E6B33B99A36286C2203D687F3377FBC685B2434518C53 could help you to find out
         LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
         BEAST (CVE-2011-3389)                     TLS1: ECDHE-RSA-AES128-SHA AES128-SHA ECDHE-RSA-AES256-SHA AES256-SHA DES-CBC3-SHA 
                                                   VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
         LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
         Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
         RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


         Done 2021-12-07 16:42:01 [  39s] -->> 172.67.21.207:443 (netology.ru) <<--
		 
		 # По остальным ip (104.22.41.171 104.22.40.171) вывод аналогичный.
		 
5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.

         Используем 2 ВМ: student-virtual-machine (10.0.2.12) и study-server (10.0.2.7)
		 # Генерируем и копируем ключи
         student@student-virtual-machine:~$ ssh-keygen
         Generating public/private rsa key pair.
         Enter file in which to save the key (/home/student/.ssh/id_rsa): 
         Enter passphrase (empty for no passphrase): 
         Enter same passphrase again: 
         Your identification has been saved in /home/student/.ssh/id_rsa
         Your public key has been saved in /home/student/.ssh/id_rsa.pub
         The key fingerprint is:
         SHA256:ncV6YMhfP/DDbbMvGq/yPUAE1hR0B4PDqN+4/SQrXzo student@student-virtual-machine
         The key's randomart image is:
         +---[RSA 3072]----+
         |          oB+o+..|
         |       . o..*. o |
         |        o.o.=.   |
         |        .+ *.= . |
         |        S.=+. *.o|
         |          o.o  +o|
         |           oo.o. |
         |          + EXo .|
         |           =B=+o.|
         +----[SHA256]-----+

         # Для копирования ключа используем утилиту ssh-copy-id
         student@student-virtual-machine:~/netology/testssl.sh$ ssh-copy-id student@10.0.2.7
         /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/student/.ssh/id_rsa.pub"
         /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
         /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys

         student@10.0.2.7's password: 

         Number of key(s) added: 1

         Now try logging into the machine, with:   "ssh 'student@10.0.2.7'"
         and check to make sure that only the key(s) you wanted were added.
         # Проверяем
         student@student-virtual-machine:~/netology/testssl.sh$ ssh student@10.0.2.7
         Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-91-generic x86_64)

          * Documentation:  https://help.ubuntu.com
          * Management:     https://landscape.canonical.com
          * Support:        https://ubuntu.com/advantage

           System information as of Tue Dec  7 14:56:24 UTC 2021

           System load:  0.08               Processes:               227
           Usage of /:   28.2% of 28.91GB   Users logged in:         1
           Memory usage: 15%                IPv4 address for ens160: 10.0.2.7
           Swap usage:   0%


         104 updates can be installed immediately.
         1 of these updates is a security update.
         To see these additional updates run: apt list --upgradable


         Last login: Tue Dec  7 14:54:12 2021 from 10.0.2.12
         student@study-server:~$ exit
         logout
         Connection to 10.0.2.7 closed.
         
		 Screenshot:
		 https://ibb.co/9VMH1br
		 
6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.
         
		 # Переименовываем ключи
		 student@student-virtual-machine:~$ cp /home/student/.ssh/id_rsa.pub /home/student/.ssh/id_rsa_study.pub
         student@student-virtual-machine:~$ cp /home/student/.ssh/id_rsa /home/student/.ssh/id_rsa_study
		 student@student-virtual-machine:~$ mv /home/student/.ssh/id_rsa /home/student/.ssh/id_rsa.old
         student@student-virtual-machine:~$ mv /home/student/.ssh/id_rsa.pub /home/student/.ssh/id_rsa.pub.old
		 student@student-virtual-machine:~$ ls -l /home/student/.ssh/
         total 24
         -rw-rw-r-- 1 student student  120 дек  7 19:05 config
         -rw------- 1 student student 2622 дек  7 19:12 id_rsa.old
         -rw-r--r-- 1 student student  585 дек  7 19:12 id_rsa.pub.old
         -rw------- 1 student student 2622 дек  7 19:17 id_rsa_study
         -rw-r--r-- 1 student student  585 дек  7 19:16 id_rsa_study.pub
         -rw-r--r-- 1 student student  223 дек  7 18:57 known_hosts
		 # Записываем конфигурацию для ключей и входа по имени
		 student@student-virtual-machine:~$ nano ~/.ssh/config
         Host study-server
         Hostname 10.0.2.7
         User student
         PubKeyAuthentication yes
         IdentityFile /home/student/.ssh/id_rsa_study
		 # Перезапускаем службу
		 student@student-virtual-machine:~$ sudo systemctl reload ssh.service
		 # Проверяем
		 student@student-virtual-machine:~$ ssh study-server 
		 
		 Screenshot
		 https://ibb.co/nmnzxCb
		 
7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.

         # Проверяем наличие tcpdump
         student@student-virtual-machine:~$ tcpdump --version
         tcpdump version 4.9.3
         libpcap version 1.10.0 (with TPACKET_V3)
         OpenSSL 1.1.1j  16 Feb 2021
		 # Собираем пакеты
		 student@student-virtual-machine:~$ sudo tcpdump -c 100 -w dump2.pcap
         tcpdump: listening on ens160, link-type EN10MB (Ethernet), capture size 262144 bytes
         100 packets captured
         244 packets received by filter
         0 packets dropped by kernel
         # Перебрасываем на машину с Wireshark
		 student@student-virtual-machine:~$ sudo cp dump2.pcap /mnt/share/dump2.pcap
		 # Смотрим результаты в Wireshark
		 
		 Screenshot
		 https://ibb.co/sC1R551
