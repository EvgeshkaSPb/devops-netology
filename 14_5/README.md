# Домашнее задание к занятию "14.5 SecurityContext, NetworkPolicies"

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

## Задача 1: Рассмотрите пример 14.5/example-security-context.yml

Создайте модуль

```
kubectl apply -f 14.5/example-security-context.yml
```

Проверьте установленные настройки внутри контейнера

```
kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
```

#### Воспроизведение

```
root@minikube:~# kubectl apply -f 14_5/example-security-context.yml 
pod/security-context-demo created
root@minikube:~# kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
root@minikube:~# kubectl get pod
NAME                    READY   STATUS      RESTARTS      AGE
14.2-netology-vault     1/1     Running     4 (22h ago)   12d
fedora                  0/1     Completed   0             11d
security-context-demo   0/1     Completed   4 (51s ago)   105s
```

## Задача 2 (*): Рассмотрите пример 14.5/example-network-policy.yml

Создайте два модуля. Для первого модуля разрешите доступ к внешнему миру
и ко второму контейнеру. Для второго модуля разрешите связь только с
первым контейнером. Проверьте корректность настроек.

### Решение

Манифесты:  
Pods  
[module1](https://github.com/EvgeshkaSPb/devops-netology/blob/main/14_5/task2/00-pod-module1.yml)  
[module2](https://github.com/EvgeshkaSPb/devops-netology/blob/main/14_5/task2/00-pod-module2.yml)  
Network Policies  
[default-deny-all](https://github.com/EvgeshkaSPb/devops-netology/blob/main/14_5/task2/00-np-default.yml) - запретить весь траффик  
[allow-dns-access](https://github.com/EvgeshkaSPb/devops-netology/blob/main/14_5/task2/01-np-dns.yml) - разрешить dns траффик  
[module1](https://github.com/EvgeshkaSPb/devops-netology/blob/main/14_5/task2/02-np-module1.yml) - политка для первого модуля  
[module2](https://github.com/EvgeshkaSPb/devops-netology/blob/main/14_5/task2/02-np-module2.yml) - политка для второго модуля  

#### Воспроизведение
1. Создаем поды и проверяем хождение трафика без политик.
```
root@minikube:~/14_5/task2/v2# kubectl apply -f 00-pod-module1.yml 
pod/module1 created
service/module1 created
root@minikube:~/14_5/task2/v2# kubectl apply -f 00-pod-module2.yml 
pod/module2 created
service/module2 created
root@minikube:~/14_5/task2/v2# kubectl get pods
NAME      READY   STATUS    RESTARTS   AGE
module1   1/1     Running   0          78s
module2   1/1     Running   0          74s
root@minikube:~/14_5/task2/v2# kubectl get services
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP    117d
module1      ClusterIP   10.109.231.10   <none>        1100/TCP   2m18s
module2      ClusterIP   10.99.124.218   <none>        2200/TCP   2m14s
root@minikube:~/14_5/task2/v2# kubectl exec module1 -- nc -zv  ya.ru 443
Connection to ya.ru 443 port [tcp/https] succeeded!
root@minikube:~/14_5/task2/v2# kubectl exec module1 -- nc -zv  module2 2200
Connection to module2 2200 port [tcp/*] succeeded!
root@minikube:~/14_5/task2/v2# kubectl exec module2 -- nc -zv  ya.ru 443
Connection to ya.ru 443 port [tcp/https] succeeded!
root@minikube:~/14_5/task2/v2# kubectl exec module2 -- nc -zv  module1 1100
Connection to module1 1100 port [tcp/*] succeeded!
```
2. Применяем сетевые политики и смотрим на результат.
```
root@minikube:~/14_5/task2/v2# kubectl apply -f 00-np-default.yml
networkpolicy.networking.k8s.io/default-deny-all created
root@minikube:~/14_5/task2/v2# kubectl apply -f 01-np-dns.yml 
networkpolicy.networking.k8s.io/allow-dns-access created
root@minikube:~/14_5/task2/v2# kubectl apply -f 02-np-module1.yml 
networkpolicy.networking.k8s.io/module1 created
root@minikube:~/14_5/task2/v2# kubectl apply -f 02-np-module2.yml 
networkpolicy.networking.k8s.io/module2 created
root@minikube:~/14_5/task2/v2# kubectl get netpol
NAME               POD-SELECTOR   AGE
allow-dns-access   <none>         21s
default-deny-all   <none>         27s
module1            role=module1   13s
module2            role=module2   8s
root@minikube:~/14_5/task2/v2# kubectl exec module1 -- nc -zv  ya.ru 443
Connection to ya.ru 443 port [tcp/https] succeeded!
root@minikube:~/14_5/task2/v2# kubectl exec module1 -- nc -zv  module2 2200
Connection to module2 2200 port [tcp/*] succeeded!
root@minikube:~/14_5/task2/v2# kubectl exec module2 -- nc -zv  module1 1100
Connection to module1 1100 port [tcp/*] succeeded!
root@minikube:~/14_5/task2/v2# kubectl exec module2 -- nc -zv -w 1  ya.ru 443
nc: connect to ya.ru port 443 (tcp) timed out: Operation in progress
nc: connect to ya.ru port 443 (tcp) timed out: Operation in progress
nc: connect to ya.ru port 443 (tcp) failed: Address not available
command terminated with exit code 1
```

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, statefulset, service) или скриншот из самого Kubernetes, что сервисы подняты и работают, а также вывод из CLI.

---
