# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : "7175" 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```
  Считаю разумным выделить адреса как строки. 

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import yaml
import os
import socket
import json
conf_file="list.json"
with open(conf_file) as json_file:
    conf = json.load(json_file)
for host, ip in conf.items():
    new_ip=socket.gethostbyname(host)
    if (ip != new_ip):
        print ('[ERROR] {} IP mismatch: {} {}'.format(host,ip,new_ip))
        conf[host]=new_ip
for host, ip in conf.items():
    print('{} - {}'.format(host,ip))
with open(conf_file, "w") as json_file:
    json.dump(conf, json_file, indent=2)
with open("list.yml", "w") as yml_file:
    yaml.dump(conf, yml_file) 	
```
#### Данную задачу я изначально решал через использование json файла, как файла истории для сверки. В этом случае я просто добавил еще и выгрузку в yaml.

### Вывод скрипта при запуске при тестировании:
```
student@student-virtual-machine:~/netology$ python3 script.py 
[ERROR] drive.google.com IP mismatch: 0.0.0.0 173.194.222.194
[ERROR] mail.google.com IP mismatch: 0.0.0.0 173.194.73.18
[ERROR] google.com IP mismatch: 0.0.0.0 74.125.131.139
drive.google.com - 173.194.222.194
mail.google.com - 173.194.73.18
google.com - 74.125.131.139

```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{
  "drive.google.com": "173.194.222.194",
  "mail.google.com": "173.194.73.18",
  "google.com": "74.125.131.139"
}

```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
drive.google.com: 173.194.222.194
google.com: 74.125.131.139
mail.google.com: 173.194.73.18

```

