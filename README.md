# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"


## Обязательная задача 1
Сценарий выполения задачи:

создайте свой репозиторий на https://hub.docker.com;
выберете любой образ, который содержит веб-сервер Nginx;
создайте свой fork образа;
реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

```
https://hub.docker.com/repository/docker/evgennetology2022/nginx
```
## Обязательная задача 2
Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

Высоконагруженное монолитное java веб-приложение;
Nodejs веб-приложение;
Мобильное приложение c версиями для Android и iOS;
Шина данных на базе Apache Kafka;
Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
Мониторинг-стек на базе Prometheus и Grafana;
MongoDB, как основное хранилище данных для java-приложения;
Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
```
Высоконагруженное монолитное java веб-приложение; - Физическая машина. Приложение монолитно (не подходят контейнеры) и нагружено (криточно быстродействие - не подходят ВМ).
Nodejs веб-приложение; - Контейнер. Одинокое приложение, без заявленной нагрузки отлично будет чувствовать себя в контейнере.
Шина данных на базе Apache Kafka; - ВМ. Относительно не высокая нагрузка, одновременно выше чем "микросервис".
Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana; - Контейнер. Я считаю что лучше распихать по контейнерам для упрощения администрирования ( мы все-же IaS изучаем :)).
Мониторинг-стек на базе Prometheus и Grafana; - Контейнер. Мы проходили это в лекции 4, микросервисы :)
MongoDB, как основное хранилище данных для java-приложения; - ВМ. В условии не указано о высокой нагрузке, по этому виртуализируем.
Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry. - ВМ + nfs шары. Нет смысла устанавливать на железо, но и в контейнер не стоит вносить во избежание потери.
```
## Обязательная задача 3
Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;
Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;
Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data;
Добавьте еще один файл в папку /data на хостовой машине;
Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.
```
Запускаем контейнеры
student@study-srv:~$ mkdir data
student@study-srv:~$ docker run -t -d -v /data:/data --name centos centos
Unable to find image 'centos:latest' locally
latest: Pulling from library/centos
a1d0c7532777: Pull complete 
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
03fe671ffa8df519f9a898ceb20dbd4254d3f79376f7ba2eacd551e8b126874e
student@study-srv:~$ docker run -t -d -v /data:/data --name debian debian
Unable to find image 'debian:latest' locally
latest: Pulling from library/debian
0c6b8ff8c37e: Pull complete 
Digest: sha256:fb45fd4e25abe55a656ca69a7bef70e62099b8bb42a279a5e0ea4ae1ab410e0d
Status: Downloaded newer image for debian:latest
4ccf9d544265f01734875eeb06a12636f85089f3ee657b4d3c6abe0c16f86d8c
student@study-srv:~$ docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
4ccf9d544265   debian    "bash"        9 seconds ago    Up 7 seconds              debian
03fe671ffa8d   centos    "/bin/bash"   38 seconds ago   Up 36 seconds             centos
student@study-srv:~$ docker exec -it centos /bin/bash 
Контейнер Centos
[root@03fe671ffa8d /]# ls
bin  data  dev	etc  home  lib	lib64  lost+found  media  mnt  opt  proc  root	run  sbin  srv	sys  tmp  usr  var
[root@03fe671ffa8d /]# touch data/test
[root@03fe671ffa8d /]# ls data/
test
[root@03fe671ffa8d /]# exit
exit
Хост
student@study-srv:/$ cd data/
student@study-srv:/data$ 
student@study-srv:/data$ touch test2
touch: cannot touch 'test2': Permission denied
student@study-srv:/data$ sudo touch test2
student@study-srv:/data$ ls
test  test2
student@study-srv:/data$ docker exec -it debian bash
Контейнер Debian 
root@4ccf9d544265:/# ls data/
test  test2
root@4ccf9d544265:/# exit
exit
```



