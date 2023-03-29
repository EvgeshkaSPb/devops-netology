# Домашнее задание к занятию "14.3 Карты конфигураций"

## Задача 1: Работа с картами конфигураций через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

#### *Версии среды 

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

### Как создать карту конфигураций?

```
kubectl create configmap nginx-config --from-file=nginx.conf
kubectl create configmap domain --from-literal=name=netology.ru
```
#### Воспроизведение

```
root@minikube:~# ls 14_3/
generator.py  myapp-pod.yml  nginx.conf  README.md  templates
root@minikube:~# kubectl create configmap nginx-config --from-file=14_3/nginx.conf
configmap/nginx-config created
root@minikube:~# kubectl create configmap domain --from-literal=name=14_3/netology.ru
configmap/domain created
```

### Как просмотреть список карт конфигураций?

```
kubectl get configmaps
kubectl get configmap
```

#### Воспроизведение
```
root@minikube:~# kubectl get configmaps
NAME               DATA   AGE
domain             1      112s
kube-root-ca.crt   1      110d
nginx-config       1      2m27s
root@minikube:~# kubectl get configmap
NAME               DATA   AGE
domain             1      2m37s
kube-root-ca.crt   1      110d
nginx-config       1      3m12s
```

### Как просмотреть карту конфигурации?

```
kubectl get configmap nginx-config
kubectl describe configmap domain
```
#### Воспроизведение
```
root@minikube:~# kubectl get configmap nginx-config
NAME           DATA   AGE
nginx-config   1      4m21s
root@minikube:~# kubectl describe configmap domain
Name:         domain
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
name:
----
14_3/netology.ru

BinaryData
====

Events:  <none>
```

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get configmap nginx-config -o yaml
kubectl get configmap domain -o json
```
#### Воспроизведение
```
root@minikube:~# kubectl get configmap nginx-config -o yaml
apiVersion: v1
data:
  nginx.conf: |
    server {
        listen 80;
        server_name  netology.ru www.netology.ru;
        access_log  /var/log/nginx/domains/netology.ru-access.log  main;
        error_log   /var/log/nginx/domains/netology.ru-error.log info;
        location / {
            include proxy_params;
            proxy_pass http://10.10.10.10:8080/;
        }
    }
kind: ConfigMap
metadata:
  creationTimestamp: "2023-03-29T17:44:13Z"
  name: nginx-config
  namespace: default
  resourceVersion: "1205773"
  uid: 8cd04a44-0ea6-4793-8400-88ec8666be34
root@minikube:~# kubectl get configmap domain -o json
{
    "apiVersion": "v1",
    "data": {
        "name": "14_3/netology.ru"
    },
    "kind": "ConfigMap",
    "metadata": {
        "creationTimestamp": "2023-03-29T17:44:48Z",
        "name": "domain",
        "namespace": "default",
        "resourceVersion": "1205800",
        "uid": "83a6837b-e83a-4c45-a7ae-da2bfa497376"
    }
}
```

### Как выгрузить карту конфигурации и сохранить его в файл?

```
kubectl get configmaps -o json > configmaps.json
kubectl get configmap nginx-config -o yaml > nginx-config.yml
```
#### Воспроизведение
```
root@minikube:~# mkdir 14_3/result
root@minikube:~# kubectl get configmaps -o json > 14_3/result/configmaps.json
root@minikube:~# kubectl get configmaps nginx-config -o yaml > 14_3/result/nginx-config.yml
root@minikube:~# ls 14_3/result/
configmaps.json  nginx-config.yml
```
[configmaps.json](https://github.com/EvgeshkaSPb/devops-netology/blob/main/14_3/result/configmaps.json)  
[nginx-config.yml](https://github.com/EvgeshkaSPb/devops-netology/blob/main/14_3/result/nginx-config.yml)

### Как удалить карту конфигурации?

```
kubectl delete configmap nginx-config
```
#### Воспроизведение
```
root@minikube:~# kubectl delete configmap nginx-config
configmap "nginx-config" deleted
```

### Как загрузить карту конфигурации из файла?

```
kubectl apply -f nginx-config.yml
```
#### Воспроизведение
```
root@minikube:~# kubectl apply -f 14_3/result/nginx-config.yml 
configmap/nginx-config created
```

## Задача 2 (*): Работа с картами конфигураций внутри модуля

Выбрать любимый образ контейнера, подключить карты конфигураций и проверить
их доступность как в виде переменных окружения, так и в виде примонтированного
тома

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, configmaps) или скриншот из самого Kubernetes, что сервисы подняты и работают, а также вывод из CLI.

---
