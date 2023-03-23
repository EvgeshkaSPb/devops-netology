root@minikube:~# kubectl apply -f vault-pod.yml 
pod/14.2-netology-vault created

# Домашнее задание к занятию "14.2 Синхронизация секретов с внешними сервисами. Vault"

### *Версии среды 

```
student@minikube:~$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 20.04.5 LTS
Release:	20.04
Codename:	focal
student@minikube:~$ minikube version
minikube version: v1.25.2
commit: 362d5fdc0a3dbee389b3d3f1034e8023e72bd3a7
```

## Задача 1: Работа с модулем Vault

Запустить модуль Vault конфигураций через утилиту kubectl в установленном minikube

```
kubectl apply -f 14.2/vault-pod.yml
```
### Воспроизведение

```
root@minikube:~# kubectl apply -f vault-pod.yml 
pod/14.2-netology-vault created
```

Получить значение внутреннего IP пода

```
kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'
```

### Воспроизведение

```
root@minikube:~# kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'
[{"ip":"172.17.0.8"}]
```

Примечание: jq - утилита для работы с JSON в командной строке

Запустить второй модуль для использования в качестве клиента

```
kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
```
### Воспроизведение

```
root@minikube:~# kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
If you don't see a command prompt, try pressing enter.
sh-5.2#
```
*Проверяем запущенные поды
```
NAME                  READY   STATUS      RESTARTS      AGE
14.2-netology-vault   1/1     Running     1 (24h ago)   25h
fedora                1/1     Running     0             42m
```

Установить дополнительные пакеты

```
dnf -y install pip
pip install hvac
```

### Воспроизведение

<details>
   <summary>Вывод консоли</summary>
   
```
sh-5.2# dnf -y install pip
Fedora 37 - x86_64                                                                                                                                         1.3 MB/s |  82 MB     01:03    
Fedora 37 openh264 (From Cisco) - x86_64                                                                                                                   1.6 kB/s | 2.5 kB     00:01    
Fedora Modular 37 - x86_64                                                                                                                                 1.7 MB/s | 3.8 MB     00:02    
Fedora 37 - x86_64 - Updates                                                                                                                               6.6 MB/s |  28 MB     00:04    
Fedora Modular 37 - x86_64 - Updates                                                                                                                       2.4 MB/s | 2.9 MB     00:01    
Last metadata expiration check: 0:00:01 ago on Thu Mar 23 17:29:21 2023.
Dependencies resolved.
===========================================================================================================================================================================================
 Package                                             Architecture                            Version                                        Repository                                Size
===========================================================================================================================================================================================
Installing:
 python3-pip                                         noarch                                  22.2.2-3.fc37                                  updates                                  3.1 M
Installing weak dependencies:
 libxcrypt-compat                                    x86_64                                  4.4.33-4.fc37                                  updates                                   91 k
 python3-setuptools                                  noarch                                  62.6.0-2.fc37                                  fedora                                   1.6 M

Transaction Summary
===========================================================================================================================================================================================
Install  3 Packages

Total download size: 4.8 M
Installed size: 23 M
Downloading Packages:
(1/3): libxcrypt-compat-4.4.33-4.fc37.x86_64.rpm                                                                                                           352 kB/s |  91 kB     00:00    
(2/3): python3-pip-22.2.2-3.fc37.noarch.rpm                                                                                                                5.8 MB/s | 3.1 MB     00:00    
(3/3): python3-setuptools-62.6.0-2.fc37.noarch.rpm                                                                                                         2.4 MB/s | 1.6 MB     00:00    
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                      4.2 MB/s | 4.8 MB     00:01     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                   1/1 
  Installing       : libxcrypt-compat-4.4.33-4.fc37.x86_64                                                                                                                             1/3 
  Installing       : python3-setuptools-62.6.0-2.fc37.noarch                                                                                                                           2/3 
  Installing       : python3-pip-22.2.2-3.fc37.noarch                                                                                                                                  3/3 
  Running scriptlet: python3-pip-22.2.2-3.fc37.noarch                                                                                                                                  3/3 
  Verifying        : python3-setuptools-62.6.0-2.fc37.noarch                                                                                                                           1/3 
  Verifying        : libxcrypt-compat-4.4.33-4.fc37.x86_64                                                                                                                             2/3 
  Verifying        : python3-pip-22.2.2-3.fc37.noarch                                                                                                                                  3/3 

Installed:
  libxcrypt-compat-4.4.33-4.fc37.x86_64                          python3-pip-22.2.2-3.fc37.noarch                          python3-setuptools-62.6.0-2.fc37.noarch                         

Complete!
sh-5.2# pip install hvac
Collecting hvac
  Downloading hvac-1.1.0-py3-none-any.whl (144 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 144.9/144.9 kB 384.8 kB/s eta 0:00:00
Collecting pyhcl<0.5.0,>=0.4.4
  Downloading pyhcl-0.4.4.tar.gz (61 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 61.1/61.1 kB 179.6 kB/s eta 0:00:00
  Installing build dependencies ... done
  Getting requirements to build wheel ... done
  Preparing metadata (pyproject.toml) ... done
Collecting requests<3.0.0,>=2.27.1
  Downloading requests-2.28.2-py3-none-any.whl (62 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 62.8/62.8 kB 82.5 kB/s eta 0:00:00
Collecting charset-normalizer<4,>=2
  Downloading charset_normalizer-3.1.0-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (197 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 197.3/197.3 kB 106.0 kB/s eta 0:00:00
Collecting idna<4,>=2.5
  Downloading idna-3.4-py3-none-any.whl (61 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 61.5/61.5 kB 254.7 kB/s eta 0:00:00
Collecting urllib3<1.27,>=1.21.1
  Downloading urllib3-1.26.15-py2.py3-none-any.whl (140 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 140.9/140.9 kB 102.8 kB/s eta 0:00:00
Collecting certifi>=2017.4.17
  Downloading certifi-2022.12.7-py3-none-any.whl (155 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 155.3/155.3 kB 226.0 kB/s eta 0:00:00
Building wheels for collected packages: pyhcl
  Building wheel for pyhcl (pyproject.toml) ... done
  Created wheel for pyhcl: filename=pyhcl-0.4.4-py3-none-any.whl size=50130 sha256=c74527df8243fde7b89a20b6a8de9190ba4ecec89f3ea1ca8676f3cc4ad1d24c
  Stored in directory: /root/.cache/pip/wheels/e4/f4/3a/691e55b36281820a2e2676ffd693a7f7a068fab60d89353d74
```
</details>

Запустить интепретатор Python и выполнить следующий код, предварительно
поменяв IP и токен

```
import hvac
client = hvac.Client(
    url='http://10.10.133.71:8200',
    token='aiphohTaa0eeHei'
)
client.is_authenticated()

# Пишем секрет
client.secrets.kv.v2.create_or_update_secret(
    path='hvac',
    secret=dict(netology='Big secret!!!'),
)

# Читаем секрет
client.secrets.kv.v2.read_secret_version(
    path='hvac',
)
```
### Воспроизведение
```
sh-5.2# python3
Python 3.11.2 (main, Feb  8 2023, 00:00:00) [GCC 12.2.1 20221121 (Red Hat 12.2.1-4)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import hvac
>>> client = hvac.Client(
...     url='http://172.17.0.8:8200',
...     token='aiphohTaa0eeHei'
... )
>>> client.is_authenticated()
True
>>> client.secrets.kv.v2.create_or_update_secret(
...     path='hvac',
...     secret=dict(netology='Big secret!!!'),
... )
{'request_id': '4db97d77-4149-70c6-4ab8-b6c75810d9e9', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'created_time': '2023-03-23T17:56:14.578835017Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>> client.secrets.kv.v2.read_secret_version(
...     path='hvac',
... )
<stdin>:1: DeprecationWarning: The raise_on_deleted parameter will change its default value to False in hvac v3.0.0. The current default of True will presere previous behavior. To use the old behavior with no warning, explicitly set this value to True. See https://github.com/hvac/hvac/pull/907
{'request_id': '94312468-8323-5c42-13a0-68d253426a4d', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'netology': 'Big secret!!!'}, 'metadata': {'created_time': '2023-03-23T17:56:14.578835017Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>>
---
```

## Задача 2 (*): Работа с секретами внутри модуля

* На основе образа fedora создать модуль;
* Создать секрет, в котором будет указан токен;
* Подключить секрет к модулю;
* Запустить модуль и проверить доступность сервиса Vault.

### Не выполнялась

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, statefulset, service) или скриншот из самого Kubernetes, что сервисы подняты и работают, а также вывод из CLI.

---