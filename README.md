          Домашнее задание к занятию "3.3. Операционные системы, лекция 1
1. 		Команда cd совершает системный вызов:
        chdir("/tmp")                           = 0
        (Получено путем сравнения выводов strace -o help.txt /bin/bash -c 'echo 1' и strace -o cd.txt /bin/bash -c 'cd /tmp')
2.      База данных file на основании которых она делает свои догдатки находится:
        /usr/share/misc/magic.mgc (так же обращается в поиске по $HOME/.magic.mgc, как я понял можно скомпилировать свою базу "магии")
        #openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
3.      Предлагаю слдеющий способ:
        # Для получения pid и файлового дескриптора
		lsof | grep deleted
        # Для смены пути записи
		kill -USR1 %pid
		# Для очистки "удаленных" файлов
		cat /dev/null > /porc/%pid/fd/%fd
4.      Зомби процессы не занимают системных ресурсов - это завершенный процесс, у которго родитель не прочел статус завершения. 
        В результате зомби висит в таблице процессов и занимает в ней место (тем и неприятен).
5.      Наверное это:'
        819    vminfo              4   0 PID    COMM               FD ERR PATH
       /var/run/utmp
        612    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
        612    dbus-daemon        18   0 /usr/share/dbus-1/system-services
        612    dbus-daemon        -1   2 /lib/dbus-1/system-services
        612    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
        636    irqbalance          6   0 /proc/interrupts
        636    irqbalance          6   0 /proc/stat
        636    irqbalance          6   0 /proc/irq/20/smp_affinity
        636    irqbalance          6   0 /proc/irq/0/smp_affinity
        636    irqbalance          6   0 /proc/irq/1/smp_affinity
        636    irqbalance          6   0 /proc/irq/8/smp_affinity
        636    irqbalance          6   0 /proc/irq/12/smp_affinity
        636    irqbalance          6   0 /proc/irq/14/smp_affinity
        636    irqbalance          6   0 /proc/irq/15/smp_affinity
        819    vminfo              4   0 /var/run/utmp
        612    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
        612    dbus-daemon        18   0 /usr/share/dbus-1/system-services
        612    dbus-daemon        -1   2 /lib/dbus-1/system-services
        612    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/'
6.     uname -a использует вызов
       "uname" в строке (execve("/usr/bin/uname", ["uname", "-a"], 0x7fff37c0f048 /* 33 vars */) = 0)
	   В man присутсвует альтернативное местоположение
	   Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.
	   # Пришлось установить дополнительные пакеты man manpages manpages-dev manpages-posix manpages-posix-dev
7.     Последовательность команд через ; - это команды выполняющиеся одна за другой, без дополнительных условий.
       Последовательность команд через && - это вторая команда выполняется только при успешном выполнении первой ( на выходе 0).
	   set -e - принудительное завершение, если команда вернула не 0.
	   Есть ли смысл использовать в bash &&, если применить set -e? Нет, не имеет.
	   # Я считаю, что set -e и && имеют разное назначение, по этому вопрос не совсем корректен. && используется для последовательного выполнения комманд и выступает оператором обьединения.
	   # set -e просто проводит проверку на успешное заверешение комманды. Но в одной строке их использование бессмысленно.
8.     set -euxo pipefail
       -e - выйти немедленно если команда вернула "не 0".
	   -u - при подстановке расценивать неустановленные переменные как ошибку.
	   -x - выводить на экран команди и аргументы во время их выполнения.
	   -o pipefail - если одна из команд в конвейере получила статус "не 0", то весь конвейер получит "не 0", а если все с 0, то 0 =).
	   Этот режим хорошо использовать в сцеариях, т.к. он не даст выполняться скрипту с ошибками и покажет нам, какая команда сейчас выполняется. Очень удобно и безопасно.
9.     Наиболее часто встречающийся статус у процессов в системе это статус S (S,Ss,SsL) - процесс находится в состоянии прерываемого ожидания, то есть ожидает какого-то события, сигнала или освобождения нужного ресурса. 
       Маленькие буквы - дополнительное описание процесса. s - лидер сеанса (первый процесс в сеансе). l - многопоточный процесс.
	   
	   
