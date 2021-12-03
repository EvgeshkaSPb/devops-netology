3.8. Компьютерные сети, лекция 3

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP

         route-views>show ip route 178.249.69.182     
         Routing entry for 178.249.69.0/24
           Known via "bgp 6447", distance 20, metric 0
           Tag 6939, type external
           Last update from 64.71.137.241 17:44:58 ago
           Routing Descriptor Blocks:
           * 64.71.137.241, from 64.71.137.241, 17:44:58 ago
               Route metric is 0, traffic share count is 1
               AS Hops 3
               Route tag 6939
               MPLS label: none
         route-views>show bgp  178.249.69.182         
         BGP routing table entry for 178.249.69.0/24, version 1391350315
         Paths: (22 available, best #22, table default)
           Not advertised to any peer
           Refresh Epoch 1
           4901 6079 9002 41722, (aggregated by 41722 91.142.95.230)
             162.250.137.254 from 162.250.137.254 (162.250.137.254)
               Origin IGP, localpref 100, valid, external
               Community: 65000:10100 65000:10300 65000:10400
               path 7FE0266B68E0 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 3
           3303 9002 41722, (aggregated by 41722 91.142.95.230)
             217.192.89.50 from 217.192.89.50 (138.187.128.158)
               Origin IGP, localpref 100, valid, external
               Community: 3303:1004 3303:1007 3303:1030 3303:3067 9002:64667
               path 7FE0DA4AAAD0 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           3267 29076 41722, (aggregated by 41722 91.142.95.233)
             194.85.40.15 from 194.85.40.15 (185.141.126.1)
               Origin IGP, metric 0, localpref 100, valid, external
               path 7FE0D882EFF0 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           57866 9002 41722, (aggregated by 41722 91.142.95.230)
             37.139.139.17 from 37.139.139.17 (37.139.139.17)
               Origin IGP, metric 0, localpref 100, valid, external
               Community: 9002:0 9002:64667
               path 7FE1171F1B08 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           7018 1299 41722, (aggregated by 41722 91.142.95.233)
             12.0.1.63 from 12.0.1.63 (12.0.1.63)
               Origin IGP, localpref 100, valid, external
               Community: 7018:5000 7018:37232
               path 7FE08F3E7820 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           3333 31133 41722, (aggregated by 41722 91.142.95.233)
             193.0.0.56 from 193.0.0.56 (193.0.0.56)
               Origin IGP, localpref 100, valid, external
               path 7FE0EB3F6DA8 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           49788 6939 50509 41722, (aggregated by 41722 91.142.95.230)
             91.218.184.60 from 91.218.184.60 (91.218.184.60)
               Origin IGP, metric 0, localpref 100, valid, external
               Community: 49788:1000
               path 7FE0E9D16358 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           20912 6939 50509 41722, (aggregated by 41722 91.142.95.230)
             212.66.96.126 from 212.66.96.126 (212.66.96.126)
               Origin IGP, localpref 100, valid, external
               Community: 20912:65016
               path 7FE17B13F4E8 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           8283 6939 50509 41722, (aggregated by 41722 91.142.95.230)
             94.142.247.3 from 94.142.247.3 (94.142.247.3)
               Origin IGP, metric 0, localpref 100, valid, external
               Community: 0:714 0:2906 0:6939 0:12876 0:12989 0:13335 0:15133 0:15169 0:16265 0:16276 0:16509 0:20940 0:22822 0:32590 0:48641 0:49029 0:57363 8283:1 8283:101 8283:103
               unknown transitive attribute: flag 0xE0 type 0x20 length 0x24
                 value 0000 205B 0000 0000 0000 0001 0000 205B
                       0000 0005 0000 0001 0000 205B 0000 0005
                       0000 0003 
               path 7FE11CD181E8 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           3356 3216 41722, (aggregated by 41722 91.142.95.233)
             4.68.4.46 from 4.68.4.46 (4.69.184.201)
               Origin IGP, metric 0, localpref 100, valid, external
               Community: 3216:2001 3216:4478 3356:2 3356:22 3356:100 3356:123 3356:503 3356:901 3356:2067
               path 7FE0CD5C07F0 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           1221 4637 9002 41722, (aggregated by 41722 91.142.95.230)
             203.62.252.83 from 203.62.252.83 (203.62.252.83)
               Origin IGP, localpref 100, valid, external
               path 7FE15930DCB8 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           852 31133 41722, (aggregated by 41722 91.142.95.233)
             154.11.12.212 from 154.11.12.212 (96.1.209.43)
               Origin IGP, metric 0, localpref 100, valid, external
               path 7FE18BD38CA8 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           2497 3216 41722, (aggregated by 41722 91.142.95.233)
             202.232.0.2 from 202.232.0.2 (58.138.96.254)
               Origin IGP, localpref 100, valid, external
               path 7FE0E8640008 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           20130 6939 50509 41722, (aggregated by 41722 91.142.95.230)
             140.192.8.16 from 140.192.8.16 (140.192.8.16)
               Origin IGP, localpref 100, valid, external
               path 7FE1555C4790 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           701 1273 3216 41722, (aggregated by 41722 91.142.95.233)
             137.39.3.55 from 137.39.3.55 (137.39.3.55)
               Origin IGP, localpref 100, valid, external
               path 7FE01EEE4C98 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           3257 1299 41722, (aggregated by 41722 91.142.95.233)
             89.149.178.10 from 89.149.178.10 (213.200.83.26)
               Origin IGP, metric 10, localpref 100, valid, external
               Community: 3257:8794 3257:30052 3257:50001 3257:54900 3257:54901
               path 7FE154B2C968 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           3549 3356 3216 41722, (aggregated by 41722 91.142.95.233)
             208.51.134.254 from 208.51.134.254 (67.16.168.191)
               Origin IGP, metric 0, localpref 100, valid, external
               Community: 3216:2001 3216:4478 3356:2 3356:22 3356:100 3356:123 3356:503 3356:901 3356:2067 3549:2581 3549:30840
               path 7FE15E6CFCC8 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           53767 6939 50509 41722, (aggregated by 41722 91.142.95.230)
             162.251.163.2 from 162.251.163.2 (162.251.162.3)
               Origin IGP, localpref 100, valid, external
               Community: 53767:2000
               path 7FE13F0FD678 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           101 6939 50509 41722, (aggregated by 41722 91.142.95.230)
             209.124.176.223 from 209.124.176.223 (209.124.176.223)
               Origin IGP, localpref 100, valid, external
               Community: 101:20300 101:22100
               path 7FE0CF3E06C0 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           3561 3910 3356 3216 41722, (aggregated by 41722 91.142.95.233)
             206.24.210.80 from 206.24.210.80 (206.24.210.80)
               Origin IGP, localpref 100, valid, external
               path 7FE0E8F4D2F8 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           1351 6939 50509 41722, (aggregated by 41722 91.142.95.230)
             132.198.255.253 from 132.198.255.253 (132.198.255.253)
               Origin IGP, localpref 100, valid, external
               path 7FE18E951468 RPKI State valid
               rx pathid: 0, tx pathid: 0
           Refresh Epoch 1
           6939 50509 41722, (aggregated by 41722 91.142.95.230)
             64.71.137.241 from 64.71.137.241 (216.218.252.164)
               Origin IGP, localpref 100, valid, external, best
               path 7FE07E481798 RPKI State valid
               rx pathid: 0, tx pathid: 0x0
			   
2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
         
		 #Создаем dummy0 интерфейс 
		 student@student-virtual-machine:~$ sudo ip link add name dummy0 type dummy
         [sudo] password for student: 
         student@student-virtual-machine:~$ sudo ip link set dummy0 up
         student@student-virtual-machine:~$ sudo ip address add 192.0.2.10/32 dev dummy0
		 # Проверяем интерфейсы и таблицу маршрутизации
         student@student-virtual-machine:~$ ip addr
         1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
             link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
             inet 127.0.0.1/8 scope host lo
                valid_lft forever preferred_lft forever
             inet6 ::1/128 scope host 
             valid_lft forever preferred_lft forever
         2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
             link/ether 00:0c:29:1e:96:54 brd ff:ff:ff:ff:ff:ff
             altname enp3s0
             inet 10.0.2.12/24 brd 10.0.2.255 scope global dynamic ens160
                valid_lft 6243sec preferred_lft 6243sec
             inet6 fe80::20c:29ff:fe1e:9654/64 scope link 
                valid_lft forever preferred_lft forever
         3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
             link/ether 12:ad:ec:c3:45:3f brd ff:ff:ff:ff:ff:ff
             inet 192.0.2.10/32 scope global dummy0
                valid_lft forever preferred_lft forever
             inet6 fe80::10ad:ecff:fec3:453f/64 scope link 
                valid_lft forever preferred_lft forever
         student@student-virtual-machine:~$ route
         Kernel IP routing table
         Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
         default         pfSense.localdo 0.0.0.0         UG    0      0        0 ens160
         10.0.2.0        0.0.0.0         255.255.255.0   U     0      0        0 ens160
         link-local      0.0.0.0         255.255.0.0     U     1000   0        0 ens160
		 # Добавляем маршруты и проверяем таблицу маршрутизации
         student@student-virtual-machine:~$ sudo ip route add 8.8.8.8 via 192.0.2.10
		 student@student-virtual-machine:~$ sudo ip route add 87.250.250.242 via 192.0.2.10
         student@student-virtual-machine:~$ sudo ip route add 94.100.180.200 via 192.0.2.10
		 student@student-virtual-machine:~$ route
         Kernel IP routing table
         Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
         default         pfSense.localdo 0.0.0.0         UG    0      0        0 ens160
         dns.google      192.0.2.10      255.255.255.255 UGH   0      0        0 dummy0
         10.0.2.0        0.0.0.0         255.255.255.0   U     0      0        0 ens160
         ya.ru           192.0.2.10      255.255.255.255 UGH   0      0        0 dummy0
         mail.ru         192.0.2.10      255.255.255.255 UGH   0      0        0 dummy0
         link-local      0.0.0.0         255.255.0.0     U     1000   0        0 ens160
		 # Проверяем работу маршрута
		 student@student-virtual-machine:~$ ping ya.ru
         PING ya.ru (87.250.250.242) 56(84) bytes of data.
         ^C
         --- ya.ru ping statistics ---
         8 packets transmitted, 0 received, 100% packet loss, time 7174ms
		 # Удаляем маршруты и проверяем
		 student@student-virtual-machine:~$ sudo ip route del 94.100.180.200 via 192.0.2.10
         student@student-virtual-machine:~$ sudo ip route del 87.250.250.242 via 192.0.2.10
         student@student-virtual-machine:~$ sudo ip route del 8.8.8.8 via 192.0.2.10
         student@student-virtual-machine:~$ route
         Kernel IP routing table
         Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
         default         pfSense.localdo 0.0.0.0         UG    0      0        0 ens160
         10.0.2.0        0.0.0.0         255.255.255.0   U     0      0        0 ens160
         link-local      0.0.0.0         255.255.0.0     U     1000   0        0 ens160
         student@student-virtual-machine:~$ ping ya.ru
         PING ya.ru (87.250.250.242) 56(84) bytes of data.
         64 bytes from ya.ru (87.250.250.242): icmp_seq=1 ttl=246 time=11.4 ms
         64 bytes from ya.ru (87.250.250.242): icmp_seq=2 ttl=246 time=11.7 ms

         --- ya.ru ping statistics ---
         2 packets transmitted, 2 received, 0% packet loss, time 1002ms

3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.

         student@student-virtual-machine:~$ sudo netstat -plnut | grep tcp
         tcp        0      0 0.0.0.0:139             0.0.0.0:*               LISTEN      1069/smbd           
         tcp        0      0 0.0.0.0:111             0.0.0.0:*               LISTEN      1/init              
         tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      670/systemd-resolve 
         tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1006/sshd: /usr/sbi 
         tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN      2680/cupsd          
         tcp        0      0 127.0.0.1:6010          0.0.0.0:*               LISTEN      5114/sshd: student@ 
         tcp        0      0 0.0.0.0:445             0.0.0.0:*               LISTEN      1069/smbd           
         tcp6       0      0 :::139                  :::*                    LISTEN      1069/smbd           
         tcp6       0      0 :::9100                 :::*                    LISTEN      1043/node_exporter  
         tcp6       0      0 :::111                  :::*                    LISTEN      1/init              
         tcp6       0      0 :::22                   :::*                    LISTEN      1006/sshd: /usr/sbi 
         tcp6       0      0 ::1:3350                :::*                    LISTEN      1000/xrdp-sesman    
         tcp6       0      0 ::1:631                 :::*                    LISTEN      2680/cupsd          
         tcp6       0      0 ::1:6010                :::*                    LISTEN      5114/sshd: student@ 
         tcp6       0      0 :::3389                 :::*                    LISTEN      1021/xr		 
		 22 tcp порт - используется SSH протоколом для удаленного управления системой
		 139 и 445 tcp порт - используются сервисом SMB для обмена файлами по локальной сети
         3350 и 3389 tcp порты - используются для XRDP. Это реализация RDP для Linux.
		 
4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?

         student@student-virtual-machine:~$ sudo netstat -plnut | grep udp
         [sudo] password for student: 
         udp        0      0 127.0.0.53:53           0.0.0.0:*                           670/systemd-resolve 
         udp        0      0 0.0.0.0:68              0.0.0.0:*                           728/dhclient        
         udp        0      0 0.0.0.0:111             0.0.0.0:*                           1/init              
         udp        0      0 192.0.2.10:137          0.0.0.0:*                           1042/nmbd           
         udp        0      0 192.0.2.10:137          0.0.0.0:*                           1042/nmbd           
         udp        0      0 10.0.2.255:137          0.0.0.0:*                           1042/nmbd           
         udp        0      0 10.0.2.12:137           0.0.0.0:*                           1042/nmbd           
         udp        0      0 0.0.0.0:137             0.0.0.0:*                           1042/nmbd           
         udp        0      0 192.0.2.10:138          0.0.0.0:*                           1042/nmbd           
         udp        0      0 192.0.2.10:138          0.0.0.0:*                           1042/nmbd           
         udp        0      0 10.0.2.255:138          0.0.0.0:*                           1042/nmbd           
         udp        0      0 10.0.2.12:138           0.0.0.0:*                           1042/nmbd           
         udp        0      0 0.0.0.0:138             0.0.0.0:*                           1042/nmbd           
         udp        0      0 0.0.0.0:5353            0.0.0.0:*                           794/avahi-daemon: r 
         udp        0      0 0.0.0.0:60932           0.0.0.0:*                           794/avahi-daemon: r 
         udp        0      0 0.0.0.0:631             0.0.0.0:*                           2683/cups-browsed   
         udp6       0      0 :::45070                :::*                                794/avahi-daemon: r 
         udp6       0      0 :::111                  :::*                                1/init              
         udp6       0      0 :::5353                 :::*                                794/avahi-daemon: r 
         68 udp - Порт DHCP клиента, по нему получены данные о DHCP сервере.
		 137 и 138 udp - Порты nmbd который обеспечивает клиентам поддержку сервера имен NetBIOS. Необходим для работы служб SMB/CIFS
		 111 udp - используется sunrpc, вообще используется всеми rpc сервисами NFS, NIS и.т.д.
         5353 и 60932 udp - используются Avahi-Daemon, системой обнаружения сервисов в локальной сети (сетевые принтеры и прочее).
		 631 udp - Используется Cups-browsed, служба для подключения удаленных принтеров.
		 
5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.

         Набросал схему сети "из головы".
		 https://ibb.co/WFXFQ9N
 

    