# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"


## Обязательная задача 1
Дайте письменые ответы на следующие вопросы:

В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
Какой алгоритм выбора лидера используется в Docker Swarm кластере?
Что такое Overlay Network?
```
Отличие replication и global в том, что в режиме replication явно указывается конкретное количество копий сервиса одноврвременно звапущенных на нодах. В режиме global сервис будет запущен на всех доступных нодах.

Изначально лидером становиться тот manager, на котором первом запустили docker swarm init =). Далее используется алгоритм Raft - алгоритм для решения задач консенсуса в сети ненадёжных вычислений.
Если обычный узел долго не получает сообщений от лидера, то он переходит в состояние «кандидат» и посылает другим узлам запрос на голосование. Другие узлы голосуют за того кандидата, от которого они получили первый запрос. 
Если кандидат получает сообщение от лидера, то он снимает свою кандидатуру и возвращается в обычное состояние. Если кандидат получает большинство голосов, то он становится лидером. 
Если же он не получил большинства (это случай, когда на кластере возникли сразу несколько кандидатов и голоса разделились), то кандидат ждёт случайное время и инициирует новую процедуру голосования.
Процедура голосования повторяется, пока не будет выбран лидер.

Overlay Network - это сеть поверх другой сети. В случае с docker swarm создается виртуальная сеть поверх основной сети (при условии прикрепленя хостов к одной сети). 
Любые точки, которые являются частью этой виртуальной сети, выглядят друг для друга так, будто они связаны поверх свича и не заботятся об устройстве основной физической сети.
Так-же можно включить шифрование в этой сети, повысив тем самым безопасность траффика.
```
## Обязательная задача 2
Создать ваш первый Docker Swarm кластер в Яндекс.Облаке
Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды: docker node ls
```
Outputs:

external_ip_address_node01 = "130.193.48.235"
external_ip_address_node02 = "130.193.49.180"
external_ip_address_node03 = "178.154.200.184"
external_ip_address_node04 = "178.154.205.6"
external_ip_address_node05 = "178.154.205.19"
external_ip_address_node06 = "130.193.49.28"
internal_ip_address_node01 = "192.168.101.11"
internal_ip_address_node02 = "192.168.101.12"
internal_ip_address_node03 = "192.168.101.13"
internal_ip_address_node04 = "192.168.101.14"
internal_ip_address_node05 = "192.168.101.15"
internal_ip_address_node06 = "192.168.101.16"
student@student-virtual-machine:~/netology/terraform$ ssh centos@130.193.48.235
[centos@node01 ~]$ sudo -i
[root@node01 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
7825abxfit8788fsk7nui9zen *   node01.netology.yc   Ready     Active         Leader           20.10.12
kgbaiyf0pf3uy23ykd2htm9jd     node02.netology.yc   Ready     Active         Reachable        20.10.12
x78e4wt9f5mj12pfp855f9l59     node03.netology.yc   Ready     Active         Reachable        20.10.12
pkmyk84cuje5j6s5iiz4gpltw     node04.netology.yc   Ready     Active                          20.10.12
or1hbl3ok26i3y84hilmmql25     node05.netology.yc   Ready     Active                          20.10.12
nmclkk65jeazchc4lne123zxk     node06.netology.yc   Ready     Active                          20.10.12
[root@node01 ~]# 
```
```
https://ibb.co/5KLyCq4
```
## Обязательная задача 3
Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.
Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
docker service ls
```
Outputs:

external_ip_address_node01 = "130.193.48.235"
external_ip_address_node02 = "130.193.49.180"
external_ip_address_node03 = "178.154.200.184"
external_ip_address_node04 = "178.154.205.6"
external_ip_address_node05 = "178.154.205.19"
external_ip_address_node06 = "130.193.49.28"
internal_ip_address_node01 = "192.168.101.11"
internal_ip_address_node02 = "192.168.101.12"
internal_ip_address_node03 = "192.168.101.13"
internal_ip_address_node04 = "192.168.101.14"
internal_ip_address_node05 = "192.168.101.15"
internal_ip_address_node06 = "192.168.101.16"
student@student-virtual-machine:~/netology/terraform$ ssh centos@130.193.48.235
[centos@node01 ~]$ sudo -i
[root@node01 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
7825abxfit8788fsk7nui9zen *   node01.netology.yc   Ready     Active         Leader           20.10.12
kgbaiyf0pf3uy23ykd2htm9jd     node02.netology.yc   Ready     Active         Reachable        20.10.12
x78e4wt9f5mj12pfp855f9l59     node03.netology.yc   Ready     Active         Reachable        20.10.12
pkmyk84cuje5j6s5iiz4gpltw     node04.netology.yc   Ready     Active                          20.10.12
or1hbl3ok26i3y84hilmmql25     node05.netology.yc   Ready     Active                          20.10.12
nmclkk65jeazchc4lne123zxk     node06.netology.yc   Ready     Active                          20.10.12
[root@node01 ~]# docker stack ls
NAME               SERVICES   ORCHESTRATOR
swarm_monitoring   8          Swarm
[root@node01 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
iy339zeaysaf   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
sbk4ioy8wijf   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
zmg5r9wb883o   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                         
oyk37eit1vy2   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                      
x2gilju8mdqi   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
ti1aivd5emjy   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0   
ljnp00hho4c2   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0       
l1zpmouupto6   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```
```
https://ibb.co/Tb1J7MD
```