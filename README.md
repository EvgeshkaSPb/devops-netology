     Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"                                                                    
1.      Команда cd является встроенной в оболочку командой (builtin). 
        <!-- Команда пренадлежит потоку stdin т.к. представляет стандартный ввод и не дает никакого вывода результата. -->
2.      grep <some_string> <some_file> -с является альтернативой. Не нужно использовать 2 команды, там где можно использовать 1 с опциями.
3.      Процесс systemd имеет pid 1 и является родителем всех процессов.
4.      ls % 2>/dev/pts/1
5.      <!-- Я не очень понял, возможно, потому что плаваю в терминологии. Стандартная команда передачи вывода >file
        Пример: ls -l > test.txt -вывод будет сохранен в test.txt
        Возможно использование команды tee
        Пример: ls -l | tee test.txt -в данном случае получим вывод на экран и сохранение в файл. -->
	Исправление по замечаниям
	Я понял в чем ошибка. я просто выполнил команду оболочки и результат отправил в файл. а нужно было выполнить команду над файлом и отправить ее результат в файл.
	по вашему примеру:
	student@student-virtual-machine:~$ wc -l /etc/passwd > result.txt
        student@student-virtual-machine:~$ cat result.txt 
        50 /etc/passwd
6.      <!-- Да возможно с помощью команды передачи вывода >
        Пример: echo HELLO >/dev/tty0
        Наблюдать результат возможно, если мы отправим команду на терминал ассоциированный с нашей консолью.
        Пример: echo HELLO >/dev/tty -->
	Исправление по замечаниям
	Я в данном случае немного схитрил. Дело в том, что у меня не срабатывало ctrl+alt+fn на моей учебной машине по терминалу xshell. Сейчас я подключился напрямую через гипервизор и все сработало.
	Как я понимаю необходима дополнительная настройка xshell для работы с функциональными клавишами. Не подскажете настроечку? =)
7.      bash 5>&1  Команда ведет к созданию нового файлового дескриптора и перенаправление на него stdout(1).
        echo netology > /proc/$$/fd/5 команда отправляется на дескриптор созданный в предыдущем шаге, а так как это дескриптор вывода, то мы получаем вывод.
        /proc/PID/fd - директория, содержащая символьные ссылки на каждый открытый файловый дескриптор.
        $$ - текущий PID.
8.      Для перенаправления stderr в Pipe и сохранении при этом вывода stdout
        ls 3>&1 1>&2 2>&3 | tee test.txt
        3>&1 – сохраняем stdout как 3
        1>&2 – отправляем stdout в stderr
        2>&3 – отправляем stderr в 3
9.      команда cat /proc/$$/environ выведет среду(окружение) указанного процесса (в данном случае пользователя)
        для пользователя можно использовать команды env и printenv
        для процесса можно использовать ps e –p PID
10.     /proc/[pid]/cmdline это файл только для чтения, который содержит полную командную строку запуска процесса, кроме тех процессов, что превратились в зомби.183-192
        /proc/[pid]/exe это является символьной ссылкой, содержащей фактическое полное имя выполняемого файла. Символьная ссылка exe может использоваться обычным образом - при попытке открыть 
        exe будет открыт исполняемый файл. 231-246
11.     SSE4_2
12.     В документации по Vagrant я нашел информацию, что по умолчанию pty или tty при подключении по ssh -отключены.
        Далее, в документации, была найдена настройка config.ssh.pty для файла Vagrantfile, которую vagrant настоятельно не рекомендует использовать.
       (https://www.vagrantup.com/docs/vagrantfile/ssh_settings#config-ssh-pty)
        Также можно использовать опцию -t при подключении по ssh.
        К сожалению, не один из этих путей не привел к результату, когда команда tty выдает положительный результат.
13.     Все заработало. Пришлось изменить /etc/sysctl.d/10-ptrace.conf настройка kernel.yama.ptrace_scope = 0
14.     tee уже применялась мной в задаче 5, она производит запись в файл с вывдом записи на экран. 
        Не работает потому, что sudo echo вызывает именно echo под правами администратора, но не записывает в файл с этими правами. 
        С использованием | sudo tee мы производим именно запись с правами администратора, т.к. pipe разделяет 2 комады которые могут выполняться с разными правами.

