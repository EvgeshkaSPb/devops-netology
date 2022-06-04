# Домашнее задание к занятию "08.03 Использование Yandex Cloud"

## Подготовьте в Yandex Cloud три хоста: для clickhouse, для vector и для lighthouse.
```
Сделано при помощи terraform. Файлы в репозиотрии,папка "yc-terraform"

Outputs:

public_ip = toset([
  "clickhouse-01 51.250.1.184",
  "lighthouse-01 51.250.12.46",
  "vector-test 51.250.3.83",
])

```
## Задача 1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает lighthouse.
```
В playbook Дописано 2 play. Play на установку Nginx сервера и Play на установку clickhouse на одной ВМ.
Так-же переработана (по сравнению с заданием 8_2) установка Vector. В этом задании он устанавливается из rpm пакета.
```
## Задача 2. При создании tasks рекомендую использовать модули: get_url, template, yum, apt
```
- При создании всех tasks для clickhouse использовался модуль ansible.builtin.get_url

- В tasks для Nginx использовался ansible.builtin.template
  Добавлен шаблон конфигурации nginx.conf.j2
- В tasks для lighthouse использовался ansible.builtin.template
  Добавлен шаблон конфигурации lighthouse.conf.j2
- В tasks для vector использовался ansible.builtin.template
  Добавлен шаблон vector.yml (разрешение использовать yml)
  Добавлен шаблон конфигурации vector.service.j2

- Во всех play использован модуль ansible.builtin.yum для установки приложений.
```
## Задача 3. Tasks должны: скачать статику lighthouse, установить nginx или любой другой webserver, настроить его конфиг для открытия lighthouse, запустить webserver.
```
Картинка
```
## Задача 4. Приготовьте свой собственный inventory файл prod.yml.
```
ссылка
```
## Задача 5. Запустите ansible-lint site.yml и исправьте ошибки, если они есть.
```
tudent@student-virtual-machine:~/AH/8_3/playbook$ ansible-lint site.yml 
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
WARNING  Listing 1 violation(s) that are fatal
unnamed-task: All tasks should be named.
site.yml:14 Task/Handler: block/always/rescue 

You can skip specific rules or tags by adding them to your configuration file:
# .config/ansible-lint.yml
warn_list:  # or 'skip_list' to silence them completely
  - unnamed-task  # All tasks should be named.

Finished with 1 failure(s), 0 warning(s) on 1 files.
```
## Задача 6. Попробуйте запустить playbook на этом окружении с флагом --check.
```
Дает ошибку и замирает на первой же task на установку т.к. пакет не скачан =)
```
## Задача 7. Запустите playbook на prod.yml окружении с флагом --diff. Убедитесь, что изменения на системе произведены.
```

PLAY RECAP *********************************************************************************************************************************************
clickhouse-01              : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=10   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-test                : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```
## Задача 8. Повторно запустите playbook с флагом --diff и убедитесь, что playbook идемпотентен.
```
TASK [Vector | Start service] **************************************************************************************************************************
changed: [vector-test]

PLAY RECAP *********************************************************************************************************************************************
clickhouse-01              : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=8    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-test                : ok=5    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```
## Задача 9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
```
Playbook содержит 4 play'я . Каждый Play содержит в себе task'и по установке Clickhouse, Vector, lighthouse и Nginx соответственно. 
Каждый play можно выполнить отдельно, используя тэги: clickhouse, vector, lighthouse, nginx.
Плейбук использует 3 файла с переменными индивидуально для каждой из группы хостов.
Так-же используются шаблоны (описанные в задаче 2)
```