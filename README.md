# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Будет выдана ошибка, т.к. мы пытаемся сложить число a (int) и строку b (str) |
| Как получить для переменной `c` значение 12?  | a= '1'; b= '2'; обе переменные строковые  |
| Как получить для переменной `c` значение 3?  | a = 1; b = 2; обе переменные - числовые  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
git_dir = '~/netology/devops-netology'
bash_command = ["cd {}".format(git_dir), "git status"]
print(git_dir)
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified: ', '')
        print(prepare_result)

```
### Вывод скрипта при запуске при тестировании:

```
student@student-virtual-machine:~/netology/devops-netology$ python3 /home/student/test.py 
~/netology/devops-netology
  README.md
  move_file/has_been_moved.txt
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
git_dir = input("input_git_directory:")
bash_command = ["cd {}".format(git_dir), "git status"]
print(git_dir)
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified: ', '')
        print(prepare_result)

```

### Вывод скрипта при запуске при тестировании:
```
student@student-virtual-machine:~/netology/terraform/terraform$ python3 /home/student/test.py 
input_git_directory:/home/student/netology/devops-netology
/home/student/netology/devops-netology
  README.md
  move_file/has_been_moved.txt
student@student-virtual-machine:~/netology/terraform/terraform$ python3 /home/student/test.py 
input_git_directory:/home/student/netology/terraform/terraform
/home/student/netology/terraform/terraform
  CHANGELOG.md

```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:

#### Однокартно запускаем скрипт для получения адресов
```python
#!/usr/bin/env python3

import socket
hosts = {'drive.google.com', 'mail.google.com', 'google.com'}
for host in hosts:
    ip = socket.gethostbyname(host)
    now = print('{}-{}'.format(host, ip))
print (now)
```
```
# Сохраняем в json для дальнейшей обработки, он будет использован при сравнении. Ставим один адрес 0.0.0.0 для проверки вывода ошибки.
{
  "drive.google.com": "173.194.222.194",
  "mail.google.com": "0.0.0.0",
  "google.com": "142.250.179.206"
}

```
```
# Запускаем скрипт проверки
```python
#!/usr/bin/env python3

import os
import socket
import json
list_file="list.json"
with open(list_file) as json_file:
    conf = json.load(json_file)
for host, ip in conf.items():
    new_ip=socket.gethostbyname(host)
    if (ip != new_ip):
        print ('[ERROR] {} IP mismatch: {} {}'.format(host,ip,new_ip))
        conf[host]=new_ip
for host, ip in conf.items():
    print('{} - {}'.format(host,ip))
with open(list_file, "w") as json_file:
    json.dump(conf, json_file, indent=2)
```

### Вывод скрипта при запуске при тестировании:
```
student@student-virtual-machine:~/netology$ python3 script.py 
[ERROR] mail.google.com IP mismatch: 0.0.0.0 142.251.36.37
drive.google.com - 173.194.222.194
mail.google.com - 142.251.36.37
google.com - 142.250.179.206
student@student-virtual-machine:~/netology$ 

```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
???
```

### Вывод скрипта при запуске при тестировании:
```
???
```
