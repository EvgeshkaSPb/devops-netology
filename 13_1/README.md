# Домашнее задание к занятию "13.1 контейнеры, поды, deployment, statefulset, services, endpoints"
Настроив кластер, подготовьте приложение к запуску в нём. Приложение стандартное: бекенд, фронтенд, база данных. Его можно найти в папке 13-kubernetes-config.

## Задание 1: подготовить тестовый конфиг для запуска приложения
Для начала следует подготовить запуск приложения в stage окружении с простыми настройками. Требования:
* под содержит в себе 2 контейнера — фронтенд, бекенд;
* регулируется с помощью deployment фронтенд и бекенд;
* база данных — через statefulset.

## *Работа выполнялась в yandex cloud
```

student@minikube:~/kubespray$ yc compute instance list
+----------------------+--------+---------------+---------+---------------+-------------+
|          ID          |  NAME  |    ZONE ID    | STATUS  |  EXTERNAL IP  | INTERNAL IP |
+----------------------+--------+---------------+---------+---------------+-------------+
| epd7q4ooih0hgj6s9rq7 | master | ru-central1-b | RUNNING | 51.250.18.223 | 10.129.0.17 |
| epd7saimtahvv4i1p7rr | node2  | ru-central1-b | RUNNING | 51.250.28.228 | 10.129.0.18 |
| epdos1s213ib5moa4ajt | node1  | ru-central1-b | RUNNING | 51.250.16.235 | 10.129.0.34 |
+----------------------+--------+---------------+---------+---------------+-------------+
```
## Решение
Создано 2 манифеста  
[deployment.yaml](https://github.com/EvgeshkaSPb/devops-netology/blob/main/13_1/task1/deployment.yaml)  
[statefulset.yaml](https://github.com/EvgeshkaSPb/devops-netology/blob/main/13_1/task1/statefulset.yaml)  

Применяем манифесты
```
root@master:~/kube-manifests/kubernetes# kubectl apply -f deployment.yaml 
deployment.apps/main created
service/frontend created
service/backend created
root@master:~/kube-manifests/kubernetes# kubectl apply -f statefulset.yaml 
statefulset.apps/db created
service/db created
root@master:~/kube-manifests/kubernetes# kubectl config set-context --current --namespace=stage
Context "kubernetes-admin@cluster.local" modified.
```
Смотрим обьекты kubernetes
```
root@master:~/kube-manifests/kubernetes# kubectl get pod
NAME                    READY   STATUS    RESTARTS   AGE
db-0                    1/1     Running   0          95s
main-84458b48db-6s8sm   2/2     Running   0          5m50s
root@master:~/kube-manifests/kubernetes# kubectl get deployments
NAME   READY   UP-TO-DATE   AVAILABLE   AGE
main   1/1     1            1           8m37s
root@master:~/kube-manifests/kubernetes# kubectl get statefulsets
NAME   READY   AGE
db     1/1     4m54s
root@master:~/kube-manifests/kubernetes# kubectl get service
NAME       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
backend    ClusterIP   10.233.44.255   <none>        9000/TCP   9m37s
db         ClusterIP   10.233.23.234   <none>        5432/TCP   5m22s
frontend   ClusterIP   10.233.46.45    <none>        8000/TCP   9m37s
```
Проверяем работоспособность frontend
```
root@master:~/kube-manifests/kubernetes# kubectl exec main-84458b48db-6s8sm -- curl localhost
Defaulted container "frontend" out of: frontend, backend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
100   448  100   448    0     0   218k      0 --:--:-- --:--:-- --:--:--  218k
```

## Задание 2: подготовить конфиг для production окружения
Следующим шагом будет запуск приложения в production окружении. Требования сложнее:
* каждый компонент (база, бекенд, фронтенд) запускаются в своем поде, регулируются отдельными deployment’ами;
* для связи используются service (у каждого компонента свой);
* в окружении фронта прописан адрес сервиса бекенда;
* в окружении бекенда прописан адрес сервиса базы данных.

## Решение

Создано 3 манифеста  
[backend.yaml](https://github.com/EvgeshkaSPb/devops-netology/blob/main/13_1/task2/backend.yaml)  
[frontend.yaml](https://github.com/EvgeshkaSPb/devops-netology/blob/main/13_1/task2/frontend.yaml)  
[db.yaml](https://github.com/EvgeshkaSPb/devops-netology/blob/main/13_1/task2/db.yaml)  

Применяем манифесты
```
root@master:~/kube-manifests/kubernetes/task2# kubectl apply -f frontend.yaml 
deployment.apps/frontend created
service/frontend created
root@master:~/kube-manifests/kubernetes/task2# kubectl apply -f backend.yaml 
deployment.apps/backend created
service/backend created
root@master:~/kube-manifests/kubernetes/task2# kubectl apply -f db.yaml 
statefulset.apps/db created
service/db created
root@master:~/kube-manifests/kubernetes/task2# kubectl config set-context --current --namespace=production
Context "kubernetes-admin@cluster.local" modified.
```
Смотрим обьекты kubernetes
```
root@master:~/kube-manifests/kubernetes/task2# kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
backend-d8f869d58-pmlng     1/1     Running   0          86s
db-0                        1/1     Running   0          80s
frontend-5bb8b9f7c8-9rncj   1/1     Running   0          93s
root@master:~/kube-manifests/kubernetes/task2# kubectl get deployments
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
backend    1/1     1            1           2m1s
frontend   1/1     1            1           2m8s
root@master:~/kube-manifests/kubernetes/task2# kubectl get statefulsets
NAME   READY   AGE
db     1/1     2m31s
root@master:~/kube-manifests/kubernetes/task2# kubectl get service
NAME       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
backend    ClusterIP   10.233.32.3     <none>        9000/TCP   3m1s
db         ClusterIP   10.233.24.116   <none>        5432/TCP   2m55s
frontend   ClusterIP   10.233.34.9     <none>        8000/TCP   3m8s
```
Проверяем работоспособность frontend
```
root@master:~/kube-manifests/kubernetes/task2# kubectl exec frontend-5bb8b9f7c8-9rncj -- curl localhost
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   448  100   448    0     0   437k      0 --:--:-- --:--:-- --:--:--  437k
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>
```

## Задание 3 (*): добавить endpoint на внешний ресурс api
Приложению потребовалось внешнее api, и для его использования лучше добавить endpoint в кластер, направленный на это api. Требования:
* добавлен endpoint до внешнего api (например, геокодер).

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, statefulset, service) или скриншот из самого Kubernetes, что сервисы подняты и работают.



