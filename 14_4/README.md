# Домашнее задание к занятию "14.4 Сервис-аккаунты"

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

## Задача 1: Работа с сервис-аккаунтами через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать сервис-аккаунт?

```
kubectl create serviceaccount netology
```
#### Воспроизведение

```
root@minikube:~# kubectl create serviceaccount netology
serviceaccount/netology created
```

### Как просмотреть список сервис-акаунтов?

```
kubectl get serviceaccounts
kubectl get serviceaccount
```
#### Воспроизведение

```
root@minikube:~# kubectl get serviceaccount
NAME       SECRETS   AGE
default    1         115d
netology   1         27s
root@minikube:~# kubectl get serviceaccounts
NAME       SECRETS   AGE
default    1         115d
netology   1         31s
```

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get serviceaccount netology -o yaml
kubectl get serviceaccount default -o json
```
#### Воспроизведение

```
root@minikube:~# kubectl get serviceaccount netology -o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2023-04-03T17:42:03Z"
  name: netology
  namespace: default
  resourceVersion: "1207107"
  uid: 1708c500-af5b-45cc-8681-877ca7d8c8de
secrets:
- name: netology-token-g8qvm
root@minikube:~# kubectl get serviceaccount default -o json
{
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "creationTimestamp": "2022-12-08T20:00:01Z",
        "name": "default",
        "namespace": "default",
        "resourceVersion": "412",
        "uid": "883c97af-ddf7-44e3-bd48-7edac1e347ee"
    },
    "secrets": [
        {
            "name": "default-token-dzwrc"
        }
    ]
}
```

### Как выгрузить сервис-акаунты и сохранить его в файл?

```
kubectl get serviceaccounts -o json > serviceaccounts.json
kubectl get serviceaccount netology -o yaml > netology.yml
```

#### Воспроизведение
```
root@minikube:~# mkdir 14_4
root@minikube:~# kubectl get serviceaccounts -o json >14_4/serviceaccounts.json
root@minikube:~# kubectl get serviceaccount netology -o yaml >14_4/netology.yml
```
[serviceaccounts.json](https://github.com/EvgeshkaSPb/devops-netology/blob/main/14_3/serviceaccounts.json)  
[netology.yml](https://github.com/EvgeshkaSPb/devops-netology/blob/main/14_3/netology.yml)

### Как удалить сервис-акаунт?

```
kubectl delete serviceaccount netology
```
#### Воспроизведение
```
root@minikube:~# kubectl delete serviceaccount netology
serviceaccount "netology" deleted
```

### Как загрузить сервис-акаунт из файла?

```
kubectl apply -f netology.yml
```
#### Воспроизведение
```
root@minikube:~# kubectl apply -f 14_4/netology.yml 
serviceaccount/netology created
root@minikube:~# kubectl get serviceaccount
NAME       SECRETS   AGE
default    1         115d
netology   2         14s
```

## Задача 2 (*): Работа с сервис-акаунтами внутри модуля

Выбрать любимый образ контейнера, подключить сервис-акаунты и проверить
доступность API Kubernetes

```
kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
```

Просмотреть переменные среды

```
env | grep KUBE
```

Получить значения переменных

```
K8S=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
SADIR=/var/run/secrets/kubernetes.io/serviceaccount
TOKEN=$(cat $SADIR/token)
CACERT=$SADIR/ca.crt
NAMESPACE=$(cat $SADIR/namespace)
```

Подключаемся к API

```
curl -H "Authorization: Bearer $TOKEN" --cacert $CACERT $K8S/api/v1/
```

В случае с minikube может быть другой адрес и порт, который можно взять здесь

```
cat ~/.kube/config
```

или здесь

```
kubectl cluster-info
```

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, serviceaccounts) или скриншот из самого Kubernetes, что сервисы подняты и работают, а также вывод из CLI.

---
