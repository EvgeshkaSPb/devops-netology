# Домашнее задание к занятию "12.1 Компоненты Kubernetes"

Вы DevOps инженер в крупной компании с большим парком сервисов. Ваша задача — разворачивать эти продукты в корпоративном кластере. 

## Задача 1: Установить Minikube

Для экспериментов и валидации ваших решений вам нужно подготовить тестовую среду для работы с Kubernetes. Оптимальное решение — развернуть на рабочей машине Minikube.

### Как поставить на AWS:
- создать EC2 виртуальную машину (Ubuntu Server 20.04 LTS (HVM), SSD Volume Type) с типом **t3.small**. Для работы потребуется настроить Security Group для доступа по ssh. Не забудьте указать keypair, он потребуется для подключения.
- подключитесь к серверу по ssh (ssh ubuntu@<ipv4_public_ip> -i <keypair>.pem)
- установите миникуб и докер следующими командами:
  - curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
  - chmod +x ./kubectl
  - sudo mv ./kubectl /usr/local/bin/kubectl
  - sudo apt-get update && sudo apt-get install docker.io conntrack -y
  - curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
- проверить версию можно командой minikube version

> Вся работа проводилась на ВМ в YandexCloud

```
student@minikube:~$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 20.04.5 LTS
Release:	20.04
Codename:	focal
```

> *Ввиду моего "позднего" занятия данной работой, вышла новая версии minikube 1.28.0
> К данной версии, текущий help по задаче не применим.
> minikube 1.28.0 требует установки cri-dockerd (https://github.com/Mirantis/cri-dockerd#build-and-instal) при параметрах --vm-driver=none.
> Если установку я победил, то настройку сетевого драйвера победить не смог.
> В итоге поднял более старую версию Minikube.

```
root@minikube:~# minikube version
minikube version: v1.25.2
commit: 362d5fdc0a3dbee389b3d3f1034e8023e72bd3a7
```

- переключаемся на root и запускаем миникуб: minikube start --vm-driver=none

```
rstudent@minikube:~$ sudo su -
root@minikube:~# minikube start --vm-driver=none
* minikube v1.25.2 on Ubuntu 20.04 (amd64)
* Using the none driver based on user configuration
* Starting control plane node minikube in cluster minikube
* Running on localhost (CPUs=2, Memory=3931MB, Disk=30169MB) ...
* minikube 1.28.0 is available! Download it: https://github.com/kubernetes/minikube/releases/tag/v1.28.0
* To disable this notice, run: 'minikube config set WantUpdateNotification false'

* OS release is Ubuntu 20.04.5 LTS
* Preparing Kubernetes v1.23.3 on Docker 20.10.21 ...
  - kubelet.resolv-conf=/run/systemd/resolve/resolv.conf
  - kubelet.housekeeping-interval=5m
    > kubectl.sha256: 64 B / 64 B [--------------------------] 100.00% ? p/s 0s
    > kubeadm.sha256: 64 B / 64 B [--------------------------] 100.00% ? p/s 0s
    > kubelet.sha256: 64 B / 64 B [--------------------------] 100.00% ? p/s 0s
    > kubectl: 44.43 MiB / 44.43 MiB [-------------] 100.00% 25.43 MiB p/s 1.9s
    > kubeadm: 43.12 MiB / 43.12 MiB [-------------] 100.00% 25.46 MiB p/s 1.9s
    > kubelet: 118.75 MiB / 118.75 MiB [-----------] 100.00% 29.48 MiB p/s 4.2s
  - Generating certificates and keys ...
  - Booting up control plane ...
  - Configuring RBAC rules ...
* Configuring local host environment ...
* 
! The 'none' driver is designed for experts who need to integrate with an existing VM
* Most users should use the newer 'docker' driver instead, which does not require root!
* For more information, see: https://minikube.sigs.k8s.io/docs/reference/drivers/none/
* 
! kubectl and minikube configuration will be stored in /root
! To use kubectl or minikube commands as your own user, you may need to relocate them. For example, to overwrite your own settings, run:
* 
  - sudo mv /root/.kube /root/.minikube $HOME
  - sudo chown -R $USER $HOME/.kube $HOME/.minikube
* 
* This can also be done automatically by setting the env var CHANGE_MINIKUBE_NONE_USER=true
* Verifying Kubernetes components...
  - Using image gcr.io/k8s-minikube/storage-provisioner:v5
* Enabled addons: default-storageclass, storage-provisioner

! /usr/local/bin/kubectl is version 1.25.4, which may have incompatibilites with Kubernetes 1.23.3.
  - Want kubectl v1.23.3? Try 'minikube kubectl -- get pods -A'
* Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default

```

- после запуска стоит проверить статус: minikube status

```
root@minikube:~# minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured

```

- запущенные служебные компоненты можно увидеть командой: kubectl get pods --namespace=kube-system

```
root@minikube:~# kubectl get pods --namespace=kube-system
NAME                               READY   STATUS    RESTARTS   AGE
coredns-64897985d-4vs4l            1/1     Running   0          9m49s
etcd-minikube                      1/1     Running   0          10m
kube-apiserver-minikube            1/1     Running   0          10m
kube-controller-manager-minikube   1/1     Running   0          10m
kube-proxy-l68vf                   1/1     Running   0          9m49s
kube-scheduler-minikube            1/1     Running   0          10m
storage-provisioner                1/1     Running   0          9m59s
```

### Для сброса кластера стоит удалить кластер и создать заново:
- minikube delete
- minikube start --vm-driver=none

Возможно, для повторного запуска потребуется выполнить команду: sudo sysctl fs.protected_regular=0

Инструкция по установке Minikube - [ссылка](https://kubernetes.io/ru/docs/tasks/tools/install-minikube/)

**Важно**: t3.small не входит во free tier, следите за бюджетом аккаунта и удаляйте виртуалку.

## Задача 2: Запуск Hello World
После установки Minikube требуется его проверить. Для этого подойдет стандартное приложение hello world. А для доступа к нему потребуется ingress.

- развернуть через Minikube тестовое приложение по [туториалу](https://kubernetes.io/ru/docs/tutorials/hello-minikube/#%D1%81%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BA%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%B0-minikube)

```
root@minikube:~# kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   1/1     1            1           8s
root@minikube:~# kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-6b89d599b9-787fl   1/1     Running   0          17s
root@minikube:~# kubectl expose deployment hello-node --type=LoadBalancer --port=8080
service/hello-node exposed
root@minikube:~# kubectl get services
NAME         TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
hello-node   LoadBalancer   10.101.221.152   <pending>     8080:30954/TCP   2s
kubernetes   ClusterIP      10.96.0.1        <none>        443/TCP          13m
root@minikube:~# minikube service hello-node
root@minikube:~# minikube service list
|-------------|------------|--------------|--------------------------|
|  NAMESPACE  |    NAME    | TARGET PORT  |           URL            |
|-------------|------------|--------------|--------------------------|
| default     | hello-node |         8080 | http://10.129.0.14:30954 |
| default     | kubernetes | No node port |
| kube-system | kube-dns   | No node port |
|-------------|------------|--------------|--------------------------|
```

- установить аддоны ingress и dashboard

```

root@minikube:~# minikube addons enable ingress
  - Using image k8s.gcr.io/ingress-nginx/controller:v1.1.1
  - Using image k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
  - Using image k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
* Verifying ingress addon...
* The 'ingress' addon is enabled
root@minikube:~# minikube addons enable dashboard
  - Using image kubernetesui/dashboard:v2.3.1
  - Using image kubernetesui/metrics-scraper:v1.0.7
* Some dashboard features require the metrics-server addon. To enable all features please run:

	minikube addons enable metrics-server	


* The 'dashboard' addon is enabled
root@minikube:~# minikube addons enable metrics-server
  - Using image k8s.gcr.io/metrics-server/metrics-server:v0.4.2
* The 'metrics-server' addon is enabled
root@minikube:~# minikube addons list | grep enabled
| dashboard                   | minikube | enabled ✅   | kubernetes                     |
| default-storageclass        | minikube | enabled ✅   | kubernetes                     |
| ingress                     | minikube | enabled ✅   | unknown (third-party)          |
| metrics-server              | minikube | enabled ✅   | kubernetes                     |
| storage-provisioner         | minikube | enabled ✅   | google                         |

```



## Задача 3: Установить kubectl

Подготовить рабочую машину для управления корпоративным кластером. Установить клиентское приложение kubectl.
- подключиться к minikube

> Для управления поднята вторая ВМ 

```
root@kubectl:~#  lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 22.04.1 LTS
Release:	22.04
Codename:	jammy
root@kubectl:~# curl http://10.129.0.14:30954
CLIENT VALUES:
client_address=172.17.0.1
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://10.129.0.14:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=10.129.0.14:30954
user-agent=curl/7.81.0
BODY:
-no body in request-root

```
Скопированны директории .kube и .minikube

```
root@kubectl:~# kubectl version --short
Flag --short has been deprecated, and will be removed in the future. The --short output will become the default.
Client Version: v1.25.4
Kustomize Version: v4.5.7
Server Version: v1.23.3
WARNING: version difference between client (1.25) and server (1.23) exceeds the supported minor version skew of +/-1

```

- проверить работу приложения из задания 2, запустив port-forward до кластера

```
root@kubectl:~# kubectl port-forward services/hello-node 8080:8080 &
[1] 1512
root@kubectl:~# Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080

root@kubectl:~# curl localhost:8080
Handling connection for 8080
CLIENT VALUES:
client_address=127.0.0.1
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://localhost:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=localhost:8080
user-agent=curl/7.81.0
BODY:
-no body in request-

```
