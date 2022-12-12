# Домашнее задание к занятию "12.2 Команды для работы с Kubernetes"
Кластер — это сложная система, с которой крайне редко работает один человек. Квалифицированный devops умеет наладить работу всей команды, занимающейся каким-либо сервисом.
После знакомства с кластером вас попросили выдать доступ нескольким разработчикам. Помимо этого требуется служебный аккаунт для просмотра логов.

Задания выполнялись на локальной ВМ
```
root@minikube:~# lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 20.04.5 LTS
Release:	20.04
Codename:	focal
root@minikube:~# minikube version
minikube version: v1.25.2
commit: 362d5fdc0a3dbee389b3d3f1034e8023e72bd3a7
```

## Задание 1: Запуск пода из образа в деплойменте
Для начала следует разобраться с прямым запуском приложений из консоли. Такой подход поможет быстро развернуть инструменты отладки в кластере. Требуется запустить деплоймент на основе образа из hello world уже через deployment. Сразу стоит запустить 2 копии приложения (replicas=2). 

Требования:
 * пример из hello world запущен в качестве deployment
 * количество реплик в deployment установлено в 2
 * наличие deployment можно проверить командой kubectl get deployment
 * наличие подов можно проверить командой kubectl get pods

```
root@minikube:~# kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4 -r 2
deployment.apps/hello-node created
root@minikube:~# kubectl get deployment

NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   2/2     2            2           34s
root@minikube:~# kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-6b89d599b9-h5cjl   1/1     Running   0          57s
hello-node-6b89d599b9-zhb9j   1/1     Running   0          57s
```

## Задание 2: Просмотр логов для разработки
Разработчикам крайне важно получать обратную связь от штатно работающего приложения и, еще важнее, об ошибках в его работе. 
Требуется создать пользователя и выдать ему доступ на чтение конфигурации и логов подов в app-namespace.

Требования: 
 * создан новый токен доступа для пользователя
 * пользователь прописан в локальный конфиг (~/.kube/config, блок users)
 * пользователь может просматривать логи подов и их конфигурацию (kubectl logs pod <pod_id>, kubectl describe pod <pod_id>)

Создаем новый namespace и добавляем в него deployment
```
root@minikube:~# kubectl create namespace app-namespace
namespace/app-namespace created
root@minikube:~# kubectl get namespace
NAME              STATUS   AGE
app-namespace     Active   9m7s
default           Active   27h
kube-node-lease   Active   28h
kube-public       Active   28h
kube-system       Active   28h
root@minikube:~# kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4 --namespace=app-namespace
deployment.apps/hello-node created
root@minikube:~# kubectl get pod --namespace=app-namespace
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-6b89d599b9-zl67t   1/1     Running   0          64s
```
Создаем пользователя для разаработки
```
root@minikube:~# useradd dev
root@minikube:~# mkdir /home/dev
root@minikube:~# cd /home/dev
root@minikube:/home/dev# openssl genrsa -out dev.key 2048
Generating RSA private key, 2048 bit long modulus (2 primes)
.....................+++++
......................+++++
e is 65537 (0x010001)
root@minikube:/home/dev# openssl req -new -key dev.key -out dev.csr -subj "/CN=dev"
root@minikube:/home/dev# openssl x509 -req -in dev.csr -CA /root/.minikube/ca.crt -CAkey /root/.minikube/ca.key -CAcreateserial -out dev.crt -days 500
Signature ok
subject=CN = dev
Getting CA Private Key
root@minikube:/home/dev# mkdir .certs && mv dev.crt dev.key .certs
root@minikube:/home/dev# kubectl config set-credentials dev --client-certificate=/home/dev/.certs/dev.crt --client-key=/home/dev/.certs/dev.key
User "dev" set.
root@minikube:/home/dev# kubectl config set-context app-namespace-dev --namespace=app-namespace --cluster=minikube --user=dev
Context "app-namespace-dev" created.
```
В результате подписанный сертификат, ключ и сертификат
```
root@minikube:/home/dev# ls
dev.csr
root@minikube:/home/dev# ls .certs/
dev.crt  dev.key
```
Создаем роль и привязку к namespace
```
root@minikube:~# cat role.yml 
 apiVersion: rbac.authorization.k8s.io/v1
 kind: Role
 metadata:
   namespace: app-namespace
   name: dev-role
 rules:
 - apiGroups: [""]
   resources: ["pods", "pods/log"]
   verbs: ["get", "list"]
root@minikube:~# kubectl apply -f role.yml
role.rbac.authorization.k8s.io/dev-role created
root@minikube:~# cat rolebind.yml 
 apiVersion: rbac.authorization.k8s.io/v1
 kind: RoleBinding
 metadata:
   name: dev-rolebinding
   namespace: app-namespace
 subjects:
 - kind: User
   name: dev
   apiGroup: rbac.authorization.k8s.io
 roleRef:
   kind: Role
   name: dev-role
   apiGroup: rbac.authorization.k8s.io
root@minikube:~# kubectl apply -f rolebind.yml 
rolebinding.rbac.authorization.k8s.io/dev-rolebinding created
```
Проверяем результаты

Сначала, что не можем выполнять 
```
root@minikube:~# kubectl get namespace
Error from server (Forbidden): namespaces is forbidden: User "dev" cannot list resource "namespaces" in API group "" at the cluster scope
root@minikube:~# kubectl delete pod hello-node-6b89d599b9-zl67t
Error from server (Forbidden): pods "hello-node-6b89d599b9-zl67t" is forbidden: User "dev" cannot delete resource "pods" in API group "" in the namespace "app-namespace"
root@minikube:~# kubectl get nodes
Error from server (Forbidden): nodes is forbidden: User "dev" cannot list resource "nodes" in API group "" at the cluster sco
```
Потом, что настраивали
```
root@minikube:~# kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-6b89d599b9-zl67t   1/1     Running   0          87m
root@minikube:~# kubectl describe pod hello-node-6b89d599b9-zl67t
Name:             hello-node-6b89d599b9-zl67t
Namespace:        app-namespace
Priority:         0
Service Account:  default
Node:             minikube/10.0.2.18
Start Time:       Sat, 10 Dec 2022 00:01:22 +0000
Labels:           app=hello-node
                  pod-template-hash=6b89d599b9
Annotations:      <none>
Status:           Running
IP:               172.17.0.5
IPs:
  IP:           172.17.0.5
Controlled By:  ReplicaSet/hello-node-6b89d599b9
Containers:
  echoserver:
    Container ID:   docker://3c80991f6c768965e2ec04918b30be0abe4e07f4c4c77578e3d161d108fbdd29
    Image:          k8s.gcr.io/echoserver:1.4
    Image ID:       docker-pullable://k8s.gcr.io/echoserver@sha256:5d99aa1120524c801bc8c1a7077e8f5ec122ba16b6dda1a5d3826057f67b9bcb
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Sat, 10 Dec 2022 00:01:23 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-64rhm (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-64rhm:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:                      <none>
root@minikube:~# kubectl logs hello-node-6b89d599b9-zl67t
root@minikube:~# 
```
*логов на данном поде не оказалось

## Задание 3: Изменение количества реплик 
Поработав с приложением, вы получили запрос на увеличение количества реплик приложения для нагрузки. Необходимо изменить запущенный deployment, увеличив количество реплик до 5. Посмотрите статус запущенных подов после увеличения реплик. 

Требования:
 * в deployment из задания 1 изменено количество реплик на 5
 * проверить что все поды перешли в статус running (kubectl get pods)

Проверяем текущую конфигурацию
```
root@minikube:~# kubectl get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   2/2     2            2           141m
root@minikube:~# kubectl get pods
NAME                          READY   STATUS    RESTARTS      AGE
hello-node-6b89d599b9-h5cjl   1/1     Running   1 (11m ago)   142m
hello-node-6b89d599b9-zhb9j   1/1     Running   1 (11m ago)   142m
```

Изменяем количество реплик
```
root@minikube:~# kubectl scale deployment hello-node --replicas=5
deployment.apps/hello-node scaled
root@minikube:~# kubectl get pods
NAME                          READY   STATUS    RESTARTS      AGE
hello-node-6b89d599b9-h5cjl   1/1     Running   1 (12m ago)   142m
hello-node-6b89d599b9-lt5gr   1/1     Running   0             3s
hello-node-6b89d599b9-px9k4   1/1     Running   0             3s
hello-node-6b89d599b9-zhb9j   1/1     Running   1 (12m ago)   142m
hello-node-6b89d599b9-zjgpx   1/1     Running   0             3s
```
