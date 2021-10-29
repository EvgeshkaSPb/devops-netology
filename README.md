     Домашнее задание к занятию "3.4. Операционные системы, лекция 2"
1.       Установлен node_exporter (wget https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz)
         Создан node_exporter.service
	     [Unit]
         Description= Node Exporter
         Wants=network-online.target
         After=network-online.target

         [Service]
         User=test_exporter
         Group=test_exporter
         Type=simple
	     EnvironmentFile=/etc/default/node_exporter
         ExecStart=/usr/local/bin/node_exporter $OPTIONS
	     Restart=on-failure

         [Install]
         WantedBy=multi-user.target
	  
	     Проверена работоспособность, в том числе и после перезагрузки
	 
	     student@student-virtual-machine:~$ ps -e | grep node_exporter
         1790 ?        00:00:00 node_exporter
         student@student-virtual-machine:~$ sudo systemctl stop node_exporter.service 
         student@student-virtual-machine:~$ ps -e | grep node_exporter
         student@student-virtual-machine:~$ sudo systemctl start node_exporter.service 
         student@student-virtual-machine:~$ ps -e | grep node_exporter
         2612 ?        00:00:00 node_exporter
2.       Опции для CPU
         # HELP node_cpu_guest_seconds_total Seconds the CPUs spent in guests (VMs) for each mode.
         # TYPE node_cpu_guest_seconds_total counter
         node_cpu_guest_seconds_total{cpu="0",mode="nice"} 0
         node_cpu_guest_seconds_total{cpu="0",mode="user"} 0
         node_cpu_guest_seconds_total{cpu="1",mode="nice"} 0
         node_cpu_guest_seconds_total{cpu="1",mode="user"} 0
         # HELP node_cpu_seconds_total Seconds the CPUs spent in each mode.
         # TYPE node_cpu_seconds_total counter
         node_cpu_seconds_total{cpu="0",mode="idle"} 2.15
         node_cpu_seconds_total{cpu="0",mode="iowait"} 0.58
         node_cpu_seconds_total{cpu="0",mode="irq"} 0
         node_cpu_seconds_total{cpu="0",mode="nice"} 0.28
         node_cpu_seconds_total{cpu="0",mode="softirq"} 0.13
         node_cpu_seconds_total{cpu="0",mode="steal"} 0
         node_cpu_seconds_total{cpu="0",mode="system"} 6.11
         node_cpu_seconds_total{cpu="0",mode="user"} 5.48
         node_cpu_seconds_total{cpu="1",mode="idle"} 3.19
         node_cpu_seconds_total{cpu="1",mode="iowait"} 0.5
         node_cpu_seconds_total{cpu="1",mode="irq"} 0
         node_cpu_seconds_total{cpu="1",mode="nice"} 0.06
         node_cpu_seconds_total{cpu="1",mode="softirq"} 0.11
         node_cpu_seconds_total{cpu="1",mode="steal"} 0
         node_cpu_seconds_total{cpu="1",mode="system"} 5.21
         node_cpu_seconds_total{cpu="1",mode="user"} 5.64
	     Опции для памяти
         # HELP node_memory_MemTotal_bytes Memory information field MemTotal_bytes.
         # TYPE node_memory_MemTotal_bytes gauge
         node_memory_MemTotal_bytes 2.074525696e+09
	     # HELP node_memory_MemFree_bytes Memory information field MemFree_bytes.
         # TYPE node_memory_MemFree_bytes gauge
         node_memory_MemFree_bytes 1.051979776e+09
	     # HELP node_memory_MemAvailable_bytes Memory information field MemAvailable_bytes.
         # TYPE node_memory_MemAvailable_bytes gauge
         node_memory_MemAvailable_bytes 1.436045312e+09
	     # HELP node_memory_Buffers_bytes Memory information field Buffers_bytes.
         # TYPE node_memory_Buffers_bytes gauge
         node_memory_Buffers_bytes 4.0927232e+07
	     # HELP node_memory_Cached_bytes Memory information field Cached_bytes.
         # TYPE node_memory_Cached_bytes gauge
         node_memory_Cached_bytes 4.67996672e+08
	     Опции для диска
	     # HELP node_disk_io_time_seconds_total Total seconds spent doing I/Os.
         # TYPE node_disk_io_time_seconds_total counter
         node_disk_io_time_seconds_total{device="sda"} 7.34
         node_disk_io_time_seconds_total{device="sr0"} 0.044
	     # HELP node_disk_read_bytes_total The total number of bytes read successfully.
         # TYPE node_disk_read_bytes_total counter
         node_disk_read_bytes_total{device="sda"} 4.52641792e+08
         node_disk_read_bytes_total{device="sr0"} 1.073152e+06
    	 # HELP node_disk_read_time_seconds_total The total number of seconds spent by all reads.
         # TYPE node_disk_read_time_seconds_total counter
         node_disk_read_time_seconds_total{device="sda"} 5.683
         node_disk_read_time_seconds_total{device="sr0"} 0.022
    	 # HELP node_disk_write_time_seconds_total This is the total number of seconds spent by all writes.
         # TYPE node_disk_write_time_seconds_total counter
         node_disk_write_time_seconds_total{device="sda"} 0.79
         node_disk_write_time_seconds_total{device="sr0"} 0
    	 Опции для сети
    	 # HELP node_network_receive_bytes_total Network device statistic receive_bytes.
         # TYPE node_network_receive_bytes_total counter
         node_network_receive_bytes_total{device="ens160"} 12999
         node_network_receive_bytes_total{device="lo"} 11806
         # HELP node_network_receive_errs_total Network device statistic receive_errs.
         # TYPE node_network_receive_errs_total counter
         node_network_receive_errs_total{device="ens160"} 0
         node_network_receive_errs_total{device="lo"} 0   
    	 # HELP node_network_transmit_bytes_total Network device statistic transmit_bytes.
         # TYPE node_network_transmit_bytes_total counter
         node_network_transmit_bytes_total{device="ens160"} 16134
         node_network_transmit_bytes_total{device="lo"} 11806
    	 # HELP node_network_transmit_errs_total Network device statistic transmit_errs.
         # TYPE node_network_transmit_errs_total counter
         node_network_transmit_errs_total{device="ens160"} 0
         node_network_transmit_errs_total{device="lo"} 0
3.       Netdata установлена и успешно запущена.
         Программа собирает довольно большой объем метрик, не вижу смысла его перечислять.
         Основное на главном экране: Used Swap(%), Disk Read(MiB/s), Disk Write(MiB/s), Total CPU utilization (all cores)(%), Net Inbound(megabits/s), Net Outbound(megabits/s), Used RAM(%)
4.       Да, можно. В строке DMI(Desktop Management Interface) обозначен производитель. В случае VM будет система виртализации
         [    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
         [    0.000000] Hypervisor detected: KVM
	      или
         [    0.000000] DMI: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 12/12/2018
         [    0.000000] Hypervisor detected: VMware
5.       fs.nr_open - системное ограничение на на максимальное количество открытых файлов на процесс. По умолчанию =  1048576
         Достичь максимального значения открытых файлов не даст "мягкое" ограничение ulimit -a 'open files (-n) 1024'
6.       Скопировал строки
         root@student-virtual-machine:~# unshare -f --pid --mount-proc sleep 1h
  	     student@student-virtual-machine:~$ ps -a
         PID TTY          TIME CMD
         893 tty1     00:00:00 dbus-run-sessio
         896 tty1     00:00:00 dbus-daemon
         916 tty1     00:00:00 gnome-session-b
         953 tty1     00:00:03 gnome-shell
         1227 tty1     00:00:00 at-spi-bus-laun
         1232 tty1     00:00:00 dbus-daemon
         1239 tty1     00:00:00 Xwayland
         1469 tty1     00:00:00 xdg-permission-
         1486 tty1     00:00:00 gjs
         1487 tty1     00:00:00 at-spi2-registr
         1490 tty1     00:00:00 gsd-sharing
         1492 tty1     00:00:00 gsd-wacom
         1495 tty1     00:00:00 gsd-color
         1498 tty1     00:00:00 gsd-keyboard
         1499 tty1     00:00:00 gsd-print-notif
         1500 tty1     00:00:00 gsd-rfkill
         1501 tty1     00:00:00 gsd-smartcard
         1503 tty1     00:00:00 gsd-datetime
         1506 tty1     00:00:00 gsd-media-keys
         1510 tty1     00:00:00 gsd-screensaver
         1516 tty1     00:00:00 gsd-sound
         1517 tty1     00:00:00 gsd-a11y-settin
         1521 tty1     00:00:00 gsd-housekeepin
         1524 tty1     00:00:00 gsd-power
         1544 tty1     00:00:00 gsd-printer
         1623 tty1     00:00:00 ibus-daemon
         1640 tty1     00:00:00 ibus-memconf
         1642 tty1     00:00:00 ibus-x11
         1646 tty1     00:00:00 ibus-portal
         1668 tty1     00:00:00 ibus-engine-sim
         2165 pts/0    00:00:00 sudo
         2174 pts/0    00:00:00 bash
         2189 pts/0    00:00:00 screen
         2225 pts/1    00:00:00 unshare
         2226 pts/1    00:00:00 sleep
         2282 pts/1    00:00:00 unshare
         2283 pts/1    00:00:00 sleep
         2886 pts/2    00:00:00 ps
         student@student-virtual-machine:~$ sudo nsenter --target 2283 --pid --mount
         [sudo] password for student: 
         root@student-virtual-machine:/# ps aux
         USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
         root           1  0.0  0.0  16752   696 pts/1    S+   21:07   0:00 sleep 1h
         root           2  0.2  0.2  19748  5460 pts/2    S    21:08   0:00 -bash
         root          11  0.0  0.1  21092  3564 pts/2    R+   21:08   0:00 ps aux
         root@student-virtual-machine:/#
7.       Команда :(){ :|:& };: - это "fork bomb", функция которая дважды вызывает сама себя при каждом вызове и не завершается.
         На счет механизмов стабилизации не знаю, после 40 минут ожидания я ребутнул virtualbox. Все это время virtualBox активно грузил процессор и делать что либо было не возможно.
	     Защитой от такого рода атак служит утсновка ulimit -u - ограничение количества процессов для пользователя. 
	 