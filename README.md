3.7. Компьютерные сети, лекция 2

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
         
		 Для Linux можно использовать команды (для некоторых возможно потребуется устновка net-tools):
      	 ip addr
         ifconfig -a
         netstat -a		 
		 Пример:
		 ifconfig -a
         ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
                 inet 10.0.2.5  netmask 255.255.255.0  broadcast 10.0.2.255
                 inet6 fe80::c2c5:3e30:e0d9:6b7a  prefixlen 64  scopeid 0x20<link>
                 ether 00:0c:29:1e:96:54  txqueuelen 1000  (Ethernet)
                 RX packets 3866  bytes 546790 (546.7 KB)
                 RX errors 0  dropped 12  overruns 0  frame 0
                 TX packets 6847  bytes 719262 (719.2 KB)
                 TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

         lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
                 inet 127.0.0.1  netmask 255.0.0.0
                 inet6 ::1  prefixlen 128  scopeid 0x10<host>
                 loop  txqueuelen 1000  (Local Loopback)
                 RX packets 389  bytes 33164 (33.1 KB)
                 RX errors 0  dropped 0  overruns 0  frame 0
                 TX packets 389  bytes 33164 (33.1 KB)
                 TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
         Для Windows можно использовать 
		 ipconfig
		 netsh interface show interface
		 Пример:
		 C:\Users\Admin>netsh interface show interface

         Состояние адм.  Состояние     Тип              Имя интерфейса
         ---------------------------------------------------------------------
         Разрешен       Подключен      Выделенный       VirtualBox Host-Only Network
         Разрешен       Отключен       Выделенный       Подключение по локальной сети
         Разрешен       Подключен      Выделенный       Ethernet
         Разрешен       Отключен       Выделенный       OpenVPN Wintun
         Разрешен       Подключен      Выделенный       OpenVPN TAP-Windows6

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого? 

         Link Layer Discovery Protocol (LLDP) — протокол канального уровня, который позволяет сетевым устройствам анонсировать в сеть информацию о себе и о своих возможностях, 
		 а также собирать эту информацию о соседних устройствах. 
		 *Специально добавил второй интерфейс для наглядности.
		 sudo apt install lldpd
		 sudo systemctl enable lldpd && systemctl start lldpd
		 lldpctl
		 -------------------------------------------------------------------------------
         LLDP neighbors:
         -------------------------------------------------------------------------------
         Interface:    ens160, via: LLDP, RID: 1, Time: 0 day, 00:06:36
           Chassis:     
             ChassisID:    mac 00:0c:29:1e:96:54
             SysName:      student-virtual-machine
             SysDescr:     Ubuntu 21.04 Linux 5.11.0-40-generic #44-Ubuntu SMP Wed Oct 20 16:16:42 UTC 2021 x86_64
             MgmtIP:       10.0.2.5
             MgmtIface:    2
             MgmtIP:       fe80::c2c5:3e30:e0d9:6b7a
             MgmtIface:    2
             Capability:   Bridge, off
             Capability:   Router, off
             Capability:   Wlan, off
             Capability:   Station, on
           Port:        
             PortID:       mac 00:0c:29:1e:96:5e
             PortDescr:    ens192
             TTL:          120
             PMD autoneg:  supported: no, enabled: no
               MAU oper type: 10GigBaseCX4 - X copper over 8 pair 100-Ohm balanced cable
         -------------------------------------------------------------------------------
         Interface:    ens192, via: LLDP, RID: 1, Time: 0 day, 00:06:36
           Chassis:     
             ChassisID:    mac 00:0c:29:1e:96:54
             SysName:      student-virtual-machine
             SysDescr:     Ubuntu 21.04 Linux 5.11.0-40-generic #44-Ubuntu SMP Wed Oct 20 16:16:42 UTC 2021 x86_64
             MgmtIP:       10.0.2.5
             MgmtIface:    2
             MgmtIP:       fe80::c2c5:3e30:e0d9:6b7a
             MgmtIface:    2
             Capability:   Bridge, off
             Capability:   Router, off
             Capability:   Wlan, off
             Capability:   Station, on
           Port:        
             PortID:       mac 00:0c:29:1e:96:54
             PortDescr:    ens160
             TTL:          120
             PMD autoneg:  supported: no, enabled: no
               MAU oper type: 10GigBaseCX4 - X copper over 8 pair 100-Ohm balanced cable
         -------------------------------------------------------------------------------
		 
3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.

         Для разделения L2 коммутатора на несколько виртуальных сетей используется VLAN (Virtual Local Area Network)
         sudo apt install vlan
		 sudo vconfig add ens192 222
		 sudo ifconfig ens192.222 10.0.2.20 netmask 255.255.255.0 up
		 ifconfig -a
		 ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
                 inet 10.0.2.5  netmask 255.255.255.0  broadcast 10.0.2.255
                 inet6 fe80::c2c5:3e30:e0d9:6b7a  prefixlen 64  scopeid 0x20<link>
                 ether 00:0c:29:1e:96:54  txqueuelen 1000  (Ethernet)
                 RX packets 912  bytes 102718 (102.7 KB)
                 RX errors 0  dropped 0  overruns 0  frame 0
                 TX packets 854  bytes 110620 (110.6 KB)
                 TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

         ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
                 inet 10.0.2.9  netmask 255.255.255.0  broadcast 10.0.2.255
                 inet6 fe80::8b56:a42a:1f8f:4b50  prefixlen 64  scopeid 0x20<link>
                 ether 00:0c:29:1e:96:5e  txqueuelen 1000  (Ethernet)
                 RX packets 417  bytes 57710 (57.7 KB)
                 RX errors 0  dropped 0  overruns 0  frame 0
                 TX packets 226  bytes 34173 (34.1 KB)
                 TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

         ens192.222: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
                 inet 10.0.2.20  netmask 255.255.255.0  broadcast 10.0.2.255
                 inet6 fe80::20c:29ff:fe1e:965e  prefixlen 64  scopeid 0x20<link>
                 ether 00:0c:29:1e:96:5e  txqueuelen 1000  (Ethernet)
                 RX packets 0  bytes 0 (0.0 B)
                 RX errors 0  dropped 0  overruns 0  frame 0
                 TX packets 70  bytes 9920 (9.9 KB)
                 TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

         lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
                 inet 127.0.0.1  netmask 255.0.0.0
                 inet6 ::1  prefixlen 128  scopeid 0x10<host>
                 loop  txqueuelen 1000  (Local Loopback)
                 RX packets 338  bytes 31785 (31.7 KB)
                 RX errors 0  dropped 0  overruns 0  frame 0
                 TX packets 338  bytes 31785 (31.7 KB)
                 TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
				 
		 В случае если мы хотим сохранить наши настройки на постоянной основе необходимо отконфигурировать netplan
		 # Let NetworkManager manage all devices on this system
         network:
           version: 2
           renderer: NetworkManager
           ethernets:
                 ens160:
                     addresses:
                         - 10.0.2.5/24
                     gateway4: 10.0.2.2
                     nameservers:
                     addresses: [10.0.2.2]
                 ens192:
                     addresses:
                         - 10.0.2.9/24
                     gateway4: 10.0.2.2
                     nameservers:
                     addresses: [10.0.2.2]
           vlans:
                 vlan222:
                     id: 222
                     link: ens192
                     addresses: [10.0.2.20/24]

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

         Я нашел информацию о двух типах агрегации интерфесов:
		 Network Bonding и Network Teaming. Второй, по сути является более современной модификацие первого.
		 Teaming - новый механизм создания агрегированных линков в Linux, более архитектурно правильный. 
		 Состоит из ядерной части, которая реализует базовые механизмы обработки трафика, и части пространства пользователя, которая отвечает за сигнализацию и управление ядерной частью.
         Опции балансировки нагрузки:
		 Mode-0(balance-rr) - По умолчанию. В данном режиме сетевые пакеты отправляются “по кругу”, от первого интерфейса к последнему. 
		 Если выходят из строя интерфейсы, пакеты отправляются на остальные оставшиеся.
		 Mode-1(active-backup) – Один из интерфейсов работает в активном режиме, остальные в ожидающем. 
		 При обнаружении проблемы на активном интерфейсе производится переключение на ожидающий интерфейс.
		 Mode-2(balance-xor) – Передача пакетов распределяется по типу входящего и исходящего трафика по формуле [( «MAC адрес источника» XOR «MAC адрес назначения») по модулю «число интерфейсов»]. 
		 Режим дает балансировку нагрузки и отказоустойчивость.
		 Mode-3(broadcast) – Происходит передача во все объединенные интерфейсы, тем самым обеспечивая отказоустойчивость.
		 Mode-4(802.3ad) – динамическое объединение одинаковых портов. 
		 В данном режиме можно значительно увеличить пропускную способность входящего так и исходящего трафика.
		 Mode-5(balance-tlb) – Адаптивная балансировки нагрузки трафика. 
		 Входящий трафик получается только активным интерфейсом, исходящий распределяется в зависимости от текущей загрузки канала каждого интерфейса.
		 Mode-6(balance-alb) – Адаптивная балансировка нагрузки. Обеспечивается балансировку нагрузки как исходящего так и входящего трафика.
		 
		 По документации есть еще один важный параметр. xmit_hash_policy - Определяет хэш политику передачи пакетов через объединенные интерфейсы в режиме balance-xor или 802.3ad.
		 Считаю важным упомянуть.
		 
		 Настроку проводил на Ubuntu 20.04.2 LTS
		 конфигурация до манипуляций
		 student@study-srv:~$ ip addr
         1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
             link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
             inet 127.0.0.1/8 scope host lo
                valid_lft forever preferred_lft forever
             inet6 ::1/128 scope host 
                valid_lft forever preferred_lft forever
         2: enp1s0f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
             link/ether 00:25:90:08:cf:50 brd ff:ff:ff:ff:ff:ff
             inet 192.168.87.23/24 brd 192.168.87.255 scope global dynamic enp1s0f0
                valid_lft 497sec preferred_lft 497sec
             inet6 fe80::225:90ff:fe08:cf50/64 scope link 
                valid_lft forever preferred_lft forever
         3: enp1s0f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
             link/ether 00:25:90:08:cf:51 brd ff:ff:ff:ff:ff:ff
             inet 192.168.87.26/24 brd 192.168.87.255 scope global dynamic enp1s0f1
                valid_lft 497sec preferred_lft 497sec
             inet6 fe80::225:90ff:fe08:cf51/64 scope link 
                valid_lft forever preferred_lft forever
				
             sudo nano /etc/netplan/00-installer-config.yaml (конфигурация агрегации)
			 # This is the network config written by 'subiquity'
         network:
           ethernets:
             enp1s0f0:
               dhcp4: false
             enp1s0f1:
               dhcp4: false
         version: 2
           bonds:
             bond0:
               interfaces:
                 - enp1s0f0
                 - enp1s0f1
               addresses: [192.168.87.50/24]
               gateway4: 192.168.87.1
               nameservers:
                 addresses: [8.8.8.8,8.8.4.4]
               parameters:
                 mode: active-backup
                 mii-monitor-interval: 100
                 primary: enp1s0f0
				 
         Конфигруация после настройки
         sudo netplan apply
         ip addr
         1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
             link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
             inet 127.0.0.1/8 scope host lo
                valid_lft forever preferred_lft forever
             inet6 ::1/128 scope host 
                valid_lft forever preferred_lft forever
         2: enp1s0f0: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master bond0 state UP group default qlen 1000
             link/ether a6:42:b6:48:76:bf brd ff:ff:ff:ff:ff:ff
         3: enp1s0f1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master bond0 state UP group default qlen 1000
             link/ether a6:42:b6:48:76:bf brd ff:ff:ff:ff:ff:ff
         4: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
             link/ether a6:42:b6:48:76:bf brd ff:ff:ff:ff:ff:ff
             inet 192.168.87.50/24 brd 192.168.87.255 scope global bond0
                valid_lft forever preferred_lft forever
             inet6 fe80::a442:b6ff:fe48:76bf/64 scope link 
                valid_lft forever preferred_lft forever
		 По рещультатам тестирования - все работает. Пинги идут в обе стороны и при работе обоих линков и при отключении primary.
		 С вашего позволения, логи пингов приводить не буду - и так работа получается слишком объемной =)
		 
5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.		 
		 
		 В сети с маской /29 количество адресов 6 + 2 адреса (network и broadcast)
		 Из сети с маской /24 можно получить 32 /29 подсети
		 Примеры подсетй:
		 10.10.10.0/29
		 10.10.10.8/29
		 10.10.10.16/29
         ~~~~~~~~~~~~~~
         10.10.10.240/29
         10.10.10.248/29

6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. 
   Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.
   
         Как вариант, можно использовать сеть из диапазона CG-NAT  100.64.0.0/26
		 
7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
         
		 Для Linux и Windows существует утилита arp. Команда arp -a (Win), arp -n (Linux) отобразит таблицу.  
		 arp -d hostname/ip удалит все записи для hostname/ip (win и Linux). 
		 Для Win очистить arp кэш можно командой netsh interface ip delete arpcache 
		 Для Linux чистить arp кэш можно командой sudo ip -s -s neigh flush all
		 

		 
		 