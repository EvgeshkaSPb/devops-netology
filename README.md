3.6. Компьютерные сети, лекция 1
	
1. Работа c HTTP через телнет.
         
         telnet stackoverflow.com 80

         Host 'stackoverflow.com' resolved to 151.101.129.69.
         Connecting to 151.101.129.69:80...
         Connection established.
         To escape to local shell, press 'Ctrl+Alt+]'.
         GET /questions HTTP/1.0
         HOST: stackoverflow.com

         HTTP/1.1 301 Moved Permanently
         cache-control: no-cache, no-store, must-revalidate
         location: https://stackoverflow.com/questions
         x-request-guid: d0f4d99e-cd73-43f9-ac51-695bf5bb7ef8
         feature-policy: microphone 'none'; speaker 'none'
         content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
         Accept-Ranges: bytes
         Date: Sun, 21 Nov 2021 17:19:29 GMT
         Via: 1.1 varnish
         Connection: close
         X-Served-By: cache-ams21044-AMS
         X-Cache: MISS
         X-Cache-Hits: 0
         X-Timer: S1637515170.634768,VS0,VE75
         Vary: Fastly-SSL
         X-DNS-Prefetch-Control: off
         Set-Cookie: prov=46437e93-7f5e-aaa8-168c-c9ee1ddc1e16; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly

         Connection closing...Socket close.

         Connection closed by foreign host.

         Disconnected from remote host(stackoverflow.com:80) at 20:19:30

         Данный ответ означает, что адрес на короый я обращаюсь - перемещен навсегда. Это связано с тем, что stackoverflow.com отвечвет только на https запросы
         и с помощью использованных команд telent мы не можем к нему подключиться.
		 
2. Повторите задание 1 в браузере, используя консоль разработчика F12.        	
         
         Браузер: Firefox Browser 94.0 (64-bit)
         Код ответа:
		 
         GET	
         scheme: http
         Host: stackoverflow.com
         filename: /
         Address: 151.101.193.69:80
         Status 301 Moved Permanently
         Version  HTTP/1.1
         Transferred 53.12 KB (175.88 KB size)
		 
         Долше всего обрабатывался запрос:
         POST
         scheme: https
         host: stats.g.doubleclick.net
         filename: /j/collect
		 
ScreenShot: https://ibb.co/JxK3yxx
		 
3. Какой IP адрес у вас в интернете? 
         
         178.249.69.182
		 
4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой whois
 
         netname:        Miran-Net
         origin:         AS41722`

5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой traceroute
         
         traceroute -A 8.8.8.8
         traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
         1  pfSense.localdomain (10.0.2.2) [*]  0.715 ms  0.658 ms  0.614 ms
         2  gw.miran.ru (178.249.69.1) [AS41722]  536.591 ms  536.562 ms  536.534 ms
         3  vl167.miran.ru (91.142.95.113) [AS41722]  536.503 ms  536.476 ms  536.442 ms
         4  vl94.miran.ru (91.142.95.48) [AS41722]  11.008 ms  10.985 ms  10.954 ms
         5  spb.piter-ix.google.com (185.1.152.26) [*]  536.291 ms  536.253 ms  536.216 ms
         6  74.125.244.133 (74.125.244.133) [AS15169]  536.187 ms 74.125.244.181 (74.125.244.181) [AS15169]  2.778 ms 74.125.244.133 (74.125.244.133) [AS15169]  0.884 ms
         7  142.251.51.187 (142.251.51.187) [AS15169]  4.664 ms  4.393 ms 72.14.232.84 (72.14.232.84) [AS15169]  1.294 ms
         8  216.239.48.163 (216.239.48.163) [AS15169]  13.996 ms 142.251.61.219 (142.251.61.219) [AS15169]  4.723 ms 216.239.48.163 (216.239.48.163) [AS15169]  13.938 ms
         9  216.239.63.27 (216.239.63.27) [AS15169]  5.185 ms * 216.239.42.21 (216.239.42.21) [AS15169]  6.156 ms
         10  * * *
         11  * * *
         12  * * *
         13  * * *
         14  * * *
         15  * * *
         16  * * *
         17  * * *
         18  dns.google (8.8.8.8) [AS15169]  4.417 ms * *
         Запрс проходит через локальную сеть (хоп 1), сеть провайдера (хоп 2-4 AS41722), пункт обмена (хоп 5), сеть google (хопы 6-18 AS15169).
		 
6. Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay? 
         
         mtr --report 8.8.8.8
         Start: 2021-11-21T21:33:23+0300
         HOST: student-virtual-machine     Loss%   Snt   Last   Avg  Best  Wrst StDev
           1.|-- pfSense.localdomain        0.0%    10    0.3   0.4   0.3   0.4   0.1
           2.|-- gw.miran.ru                0.0%    10    1.0   0.8   0.7   1.0   0.1
           3.|-- vl167.miran.ru             0.0%    10    1.2   1.5   1.1   2.6   0.4
           4.|-- vl94.miran.ru              0.0%    10    0.9   1.1   0.6   3.5   0.9
           5.|-- spb.piter-ix.google.com    0.0%    10    1.1   1.1   0.9   1.4   0.1
           6.|-- 74.125.244.133             0.0%    10    1.2   1.2   1.0   1.6   0.2
           7.|-- 142.251.51.187             0.0%    10    4.8   5.5   4.6  12.2   2.4
           8.|-- 142.250.56.13              0.0%    10    4.5   4.6   4.4   4.8   0.1
           9.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
          10.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
          11.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
          12.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
          13.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
          14.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
          15.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
          16.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
          17.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
          18.|-- dns.google                 0.0%    10    4.5   4.6   4.3   4.8   0.2
         Судя по данномы выводу, наибольшая задержка на 7ом участке 142.251.51.187 Avg 5.5
		 
7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой dig
         
         dig dns.google

         ; <<>> DiG 9.16.8-Ubuntu <<>> dns.google
         ;; global options: +cmd
         ;; Got answer:
         ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 20767
         ;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

         ;; OPT PSEUDOSECTION:
         ; EDNS: version: 0, flags:; udp: 65494
         ;; QUESTION SECTION:
         ;dns.google.			IN	A

         ;; ANSWER SECTION:
         dns.google.		900	IN	A	8.8.8.8
         dns.google.		900	IN	A	8.8.4.4

         ;; Query time: 611 msec
         ;; SERVER: 127.0.0.53#53(127.0.0.53)
         ;; WHEN: Пн ноя 22 14:43:39 MSK 2021
         ;; MSG SIZE  rcvd: 71
         За доменное имя dns.google отвечают сервера 8.8.8.8 и 8.8.4.4
		 
9. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой dig
         
         dig -x 8.8.8.8 +noall +answer
         8.8.8.8.in-addr.arpa.	6993	IN	PTR	dns.google.
         Для ip 8.8.8.8 ptr запись 8.8.8.8.in-addr.arpa., домен dns.google.
		
         dig -x 8.8.4.4 +noall +answer
         4.4.8.8.in-addr.arpa.	86400	IN	PTR	dns.google.
         Для ip 8.8.4.4 ptr запись 4.4.8.8.in-addr.arpa., домен dns.google.
		 