# Домашнее задание к занятию "12.4 Развертывание кластера на собственных серверах, лекция 2"
Новые проекты пошли стабильным потоком. Каждый проект требует себе несколько кластеров: под тесты и продуктив. Делать все руками — не вариант, поэтому стоит автоматизировать подготовку новых кластеров.

## Задание 1: Подготовить инвентарь kubespray
Новые тестовые кластеры требуют типичных простых настроек. Нужно подготовить инвентарь и проверить его работу. Требования к инвентарю:
* подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды;
* в качестве CRI — containerd;
* запуск etcd производить на мастере.

## Решение

Создаем виртуальные машины в Yandex Cloud
```
student@minikube:~$ yc compute instance list
+----------------------+-------+---------------+---------+----------------+-------------+
|          ID          | NAME  |    ZONE ID    | STATUS  |  EXTERNAL IP   | INTERNAL IP |
+----------------------+-------+---------------+---------+----------------+-------------+
| epd243scrd6n7kmmuorb | node2 | ru-central1-b | RUNNING | 51.250.101.194 | 10.129.0.19 |
| epd33ca0kv7hollsdvm1 | node5 | ru-central1-b | RUNNING | 51.250.28.206  | 10.129.0.20 |
| epdgjqq1a381ib04joq4 | node4 | ru-central1-b | RUNNING | 51.250.104.7   | 10.129.0.9  |
| epdm4m2o4kukecf9o2v9 | node1 | ru-central1-b | RUNNING | 51.250.26.131  | 10.129.0.34 |
| epds4orqb3np9k7t1a4a | node3 | ru-central1-b | RUNNING | 51.250.111.31  | 10.129.0.17 |
+----------------------+-------+---------------+---------+----------------+-------------+
```
Скачиваем kubespray и устаеавливаем зависимости
```
student@minikube:~$ sudo apt update
student@minikube:~$ sudo apt install pip git
student@minikube:~$ git clone https://github.com/kubernetes-sigs/kubespray
student@minikube:~$ cd kubespray/
student@minikube:~/kubespray$ sudo pip3 install -r requirements.txt
```
Настравиваем inventory
```
student@minikube:~/kubespray$ cp -rfp inventory/sample/ inventory/my_cluster

student@minikube:~/kubespray$ cat inventory/my_cluster/inventory.ini 
[all]
node1 ansible_host=51.250.26.131
node2 ansible_host=51.250.101.194
node3 ansible_host=51.250.111.31
node4 ansible_host=51.250.104.7
node5 ansible_host=51.250.28.206

[kube_control_plane]
node1

[etcd]
node1

[kube_node]
node2
node3
node4
node5

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
calico_rr
```
Проверяем настройку CRI

```
student@minikube:~/kubespray$ cat inventory/my_cluster/group_vars/k8s_cluster/k8s-cluster.yml | grep container_manager
container_manager: containerd
```

Запускаем установку кластера

```
ansible-playbook -i inventory/my_cluster/inventory.ini cluster.yml -b -v
```
Вывод результата установки

<details>

<summary>Вывод</summary>

```
PLAY RECAP ********************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node1                      : ok=725  changed=142  unreachable=0    failed=0    skipped=1262 rescued=0    ignored=9   
node2                      : ok=503  changed=90   unreachable=0    failed=0    skipped=780  rescued=0    ignored=2   
node3                      : ok=503  changed=90   unreachable=0    failed=0    skipped=779  rescued=0    ignored=2   
node4                      : ok=503  changed=90   unreachable=0    failed=0    skipped=779  rescued=0    ignored=2   
node5                      : ok=503  changed=90   unreachable=0    failed=0    skipped=779  rescued=0    ignored=2   

Thursday 22 December 2022  18:00:27 +0000 (0:00:00.230)       0:17:44.988 ***** 
=============================================================================== 
kubernetes/kubeadm : Join to cluster ---------------------------------------------------------------------------------------------------------------------------------------------- 33.74s
kubernetes/preinstall : Install packages requirements ----------------------------------------------------------------------------------------------------------------------------- 26.21s
download : download_file | Validate mirrors --------------------------------------------------------------------------------------------------------------------------------------- 25.43s
kubernetes/control-plane : kubeadm | Initialize first master ---------------------------------------------------------------------------------------------------------------------- 15.83s
kubernetes-apps/ansible : Kubernetes Apps | Lay Down CoreDNS templates ------------------------------------------------------------------------------------------------------------ 14.95s
kubernetes-apps/ansible : Kubernetes Apps | Start Resources ----------------------------------------------------------------------------------------------------------------------- 13.08s
network_plugin/calico : Wait for calico kubeconfig to be created ------------------------------------------------------------------------------------------------------------------ 12.91s
download : download_container | Download image if required ------------------------------------------------------------------------------------------------------------------------ 11.41s
download : download_container | Download image if required ------------------------------------------------------------------------------------------------------------------------ 10.52s
network_plugin/calico : Calico | Create calico manifests --------------------------------------------------------------------------------------------------------------------------- 9.00s
kubernetes/preinstall : Preinstall | wait for the apiserver to be running ---------------------------------------------------------------------------------------------------------- 8.75s
kubernetes/preinstall : Update package management cache (APT) ---------------------------------------------------------------------------------------------------------------------- 8.73s
download : download_container | Download image if required ------------------------------------------------------------------------------------------------------------------------- 7.37s
download : download_container | Download image if required ------------------------------------------------------------------------------------------------------------------------- 7.27s
network_plugin/calico : Start Calico resources ------------------------------------------------------------------------------------------------------------------------------------- 6.74s
download : download_container | Download image if required ------------------------------------------------------------------------------------------------------------------------- 6.50s
etcd : reload etcd ----------------------------------------------------------------------------------------------------------------------------------------------------------------- 6.42s
policy_controller/calico : Create calico-kube-controllers manifests ---------------------------------------------------------------------------------------------------------------- 5.98s
download : download_container | Download image if required ------------------------------------------------------------------------------------------------------------------------- 5.94s
etcd : Configure | Check if etcd cluster is healthy -------------------------------------------------------------------------------------------------------------------------------- 5.80s
```

</details>

Проверяем результаты

```
student@minikube:~/kubespray$ ssh student@51.250.26.131
student@node1:~$ sudo su
root@node1:/home/student# kubectl get nodes
NAME    STATUS   ROLES           AGE     VERSION
node1   Ready    control-plane   8m43s   v1.25.5
node2   Ready    <none>          7m21s   v1.25.5
node3   Ready    <none>          7m21s   v1.25.5
node4   Ready    <none>          7m21s   v1.25.5
node5   Ready    <none>          7m21s   v1.25.5
root@node1:/home/student# kubectl get pods --all-namespaces
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-75748cc9fd-cw75z   1/1     Running   0          6m42s
kube-system   calico-node-9z9m5                          1/1     Running   0          7m31s
kube-system   calico-node-j8tpb                          1/1     Running   0          7m31s
kube-system   calico-node-q64d5                          1/1     Running   0          7m31s
kube-system   calico-node-tzxpf                          1/1     Running   0          7m31s
kube-system   calico-node-v8vc6                          1/1     Running   0          7m31s
kube-system   coredns-588bb58b94-f2hkx                   1/1     Running   0          6m8s
kube-system   coredns-588bb58b94-vgxx9                   1/1     Running   0          5m58s
kube-system   dns-autoscaler-5b9959d7fc-9jhhz            1/1     Running   0          6m1s
kube-system   kube-apiserver-node1                       1/1     Running   1          9m39s
kube-system   kube-controller-manager-node1              1/1     Running   1          9m39s
kube-system   kube-proxy-2cf94                           1/1     Running   0          8m17s
kube-system   kube-proxy-9h424                           1/1     Running   0          8m17s
kube-system   kube-proxy-jhf8p                           1/1     Running   0          8m17s
kube-system   kube-proxy-nc5pt                           1/1     Running   0          8m17s
kube-system   kube-proxy-plzv8                           1/1     Running   0          8m17s
kube-system   kube-scheduler-node1                       1/1     Running   1          9m39s
kube-system   nginx-proxy-node2                          1/1     Running   0          7m13s
kube-system   nginx-proxy-node3                          1/1     Running   0          7m15s
kube-system   nginx-proxy-node4                          1/1     Running   0          6m59s
kube-system   nginx-proxy-node5                          1/1     Running   0          7m10s
kube-system   nodelocaldns-ctwrf                         1/1     Running   0          6m
kube-system   nodelocaldns-f4tcn                         1/1     Running   0          6m
kube-system   nodelocaldns-sxt2c                         1/1     Running   0          6m1s
kube-system   nodelocaldns-t88kb                         1/1     Running   0          6m1s
kube-system   nodelocaldns-wd6qj                         1/1     Running   0          6m1s
```
Проверим CRI
```
root@node1:/home/student# kubectl get node node2 -o jsonpath="{.status.nodeInfo.containerRuntimeVersion}"
containerd://1.6.14
```
Запустим тестовый pod
```
root@node1:/home/student# kubectl run nginx --image=nginx
pod/nginx create
droot@node1:/home/student# kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          12s
```

Установка выполнена успешно.


