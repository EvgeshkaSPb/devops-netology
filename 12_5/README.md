# Домашнее задание к занятию "12.5 Сетевые решения CNI"
После работы с Flannel появилась необходимость обеспечить безопасность для приложения. Для этого лучше всего подойдет Calico.
## Задание 1: установить в кластер CNI плагин Calico
Для проверки других сетевых решений стоит поставить отличный от Flannel плагин — например, Calico. Требования: 
* установка производится через ansible/kubespray;
* после применения следует настроить политику доступа к hello-world извне. Инструкции [kubernetes.io](https://kubernetes.io/docs/concepts/services-networking/network-policies/), [Calico](https://docs.projectcalico.org/about/about-network-policy)

## Решение

Проверяем конфигурацию сетевого плагина
```
student@minikube:~/kubespray$ cat inventory/my_cluster/group_vars/k8s_cluster/k8s-cluster.yml | grep  kube_network_plugin
kube_network_plugin: calico
```
Создаем кластер при помощи kybesray [inventory.ini](https://github.com/EvgeshkaSPb/devops-netology/blob/main/12_5/inventory.ini)
```
student@minikube:~$ yc compute instance list
+----------------------+---------+---------------+---------+----------------+-------------+
|          ID          |  NAME   |    ZONE ID    | STATUS  |  EXTERNAL IP   | INTERNAL IP |
+----------------------+---------+---------------+---------+----------------+-------------+
| epdhtrqhk9getkir3l3c | worker1 | ru-central1-b | RUNNING | 51.250.110.52  | 10.129.0.34 |
| epdukf91pisfmm067o4i | cp1     | ru-central1-b | RUNNING | 84.201.155.128 | 10.129.0.15 |
+----------------------+---------+---------------+---------+----------------+-------------+
```
Создаем 2 пода и обьединем их в сервис
```
root@cp1:~# kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4 --replicas=2
deployment.apps/hello-node created
root@cp1:~# kubectl expose deployment hello-node --type=LoadBalancer --port=8080
service/hello-node exposed
```
Проверяем результаты
```
root@cp1:~# kubectl get pods -o wide
NAME                         READY   STATUS    RESTARTS   AGE   IP               NODE      NOMINATED NODE   READINESS GATES
hello-node-697897c86-7mm2t   1/1     Running   0          73s   10.233.105.132   worker1   <none>           <none>
hello-node-697897c86-9cctr   1/1     Running   0          73s   10.233.105.131   worker1   <none>           <none>
root@cp1:~# kubectl get services -o wide
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE   SELECTOR
hello-node   LoadBalancer   10.233.16.219   <pending>     8080:30725/TCP   77s   app=hello-node
kubernetes   ClusterIP      10.233.0.1      <none>        443/TCP          39m   <none>
root@cp1:~# ls /etc/cni/net.d
10-calico.conflist  calico.conflist.template  calico-kubeconfig
```
Проверяем сетевую доступность между подами
```
root@cp1:~# kubectl exec -it hello-node-697897c86-7mm2t -- curl 10.233.105.131:8080
CLIENT VALUES:
client_address=10.233.105.132
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://10.233.105.131:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=10.233.105.131:8080
user-agent=curl/7.47.0
BODY:
-no body in request-

root@cp1:~# kubectl exec -it hello-node-697897c86-9cctr -- curl 10.233.105.132:8080
CLIENT VALUES:
client_address=10.233.105.131
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://10.233.105.132:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=10.233.105.132:8080
user-agent=curl/7.47.0
BODY:
-no body in request-
```
И сервиса снаружи
```
student@minikube:~$ curl http://84.201.155.128:30725
CLIENT VALUES:
client_address=10.233.116.128
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://84.201.155.128:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=84.201.155.128:30725
user-agent=curl/7.68.0
BODY:
-no body in request-
```
Создаем и применяем правило запрещающее доступ по сети [deny-ingress.yaml](https://github.com/EvgeshkaSPb/devops-netology/blob/main/12_5/deny-ingress.yaml)
```
root@cp1:~# kubectl apply -f deny-ingress.yaml
networkpolicy.networking.k8s.io/deny-ingress created
```
Проверяем, что доступ пропал как снаружи, так и между подами
```
student@minikube:~$ curl -m 1 http://84.201.155.128:30725
curl: (28) Connection timed out after 1001 milliseconds

root@cp1:~# kubectl exec -it hello-node-697897c86-9cctr -- curl -m 1 10.233.105.132:8080
curl: (28) Connection timed out after 1000 milliseconds
````
Создаем и применяем правило разрешающе доступ между подами [pod-communication.yaml](https://github.com/EvgeshkaSPb/devops-netology/blob/main/12_5/pod-communication.yaml)
```
root@cp1:~# kubectl apply -f pod-communication.yaml 
networkpolicy.networking.k8s.io/pod-communication created
```
Проверяем доступ между подами и отсутствие доступа снаружи

```
root@cp1:~# kubectl exec -it hello-node-697897c86-9cctr -- curl -m 1 10.233.105.132:8080
CLIENT VALUES:
client_address=10.233.105.131
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://10.233.105.132:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=10.233.105.132:8080
user-agent=curl/7.47.0
BODY:
-no body in request-

student@minikube:~$ curl -m 1 http://84.201.155.128:30725
curl: (28) Connection timed out after 1001 milliseconds
```
Список правил
```
root@cp1:~# kubectl get netpol -A
NAMESPACE   NAME                POD-SELECTOR     AGE
default     deny-ingress        app=hello-node   27m
default     pod-communication   app=hello-node   23m
```
## Задание 2: изучить, что запущено по умолчанию
Самый простой способ — проверить командой calicoctl get <type>. Для проверки стоит получить список нод, ipPool и profile.
Требования: 
* установить утилиту calicoctl;
* получить 3 вышеописанных типа в консоли.

## Решение

Устанавливаем calicoctl

```
root@cp1:~# curl -L https://github.com/projectcalico/calico/releases/download/v3.24.5/calicoctl-linux-amd64 -o calicoctl
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 56.7M  100 56.7M    0     0  14.2M      0  0:00:03  0:00:03 --:--:-- 15.7M
```
Получаем типы в консоли

````
root@cp1:~# calicoctl get node
NAME      
cp1       
worker1   

root@cp1:~# calicoctl get ipPool
NAME           CIDR             SELECTOR   
default-pool   10.233.64.0/18   all()      

root@cp1:~# calicoctl get profile
NAME                                                 
projectcalico-default-allow                          
kns.default                                          
kns.kube-node-lease                                  
kns.kube-public                                      
kns.kube-system                                      
ksa.default.default                                  
ksa.kube-node-lease.default                          
ksa.kube-public.default                              
ksa.kube-system.attachdetach-controller              
ksa.kube-system.bootstrap-signer                     
ksa.kube-system.calico-kube-controllers              
ksa.kube-system.calico-node                          
ksa.kube-system.certificate-controller               
ksa.kube-system.clusterrole-aggregation-controller   
ksa.kube-system.coredns                              
ksa.kube-system.cronjob-controller                   
ksa.kube-system.daemon-set-controller                
ksa.kube-system.default                              
ksa.kube-system.deployment-controller                
ksa.kube-system.disruption-controller                
ksa.kube-system.dns-autoscaler                       
ksa.kube-system.endpoint-controller                  
ksa.kube-system.endpointslice-controller             
ksa.kube-system.endpointslicemirroring-controller    
ksa.kube-system.ephemeral-volume-controller          
ksa.kube-system.expand-controller                    
ksa.kube-system.generic-garbage-collector            
ksa.kube-system.horizontal-pod-autoscaler            
ksa.kube-system.job-controller                       
ksa.kube-system.kube-proxy                           
ksa.kube-system.namespace-controller                 
ksa.kube-system.node-controller                      
ksa.kube-system.nodelocaldns                         
ksa.kube-system.persistent-volume-binder             
ksa.kube-system.pod-garbage-collector                
ksa.kube-system.pv-protection-controller             
ksa.kube-system.pvc-protection-controller            
ksa.kube-system.replicaset-controller                
ksa.kube-system.replication-controller               
ksa.kube-system.resourcequota-controller             
ksa.kube-system.root-ca-cert-publisher               
ksa.kube-system.service-account-controller           
ksa.kube-system.service-controller                   
ksa.kube-system.statefulset-controller               
ksa.kube-system.token-cleaner                        
ksa.kube-system.ttl-after-finished-controller        
ksa.kube-system.ttl-controller
````