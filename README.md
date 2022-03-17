# Домашнее задание к занятию "6.4. PostgreSQL"


## Обязательная задача 1

Используя докер образ centos:7 как базовый и документацию по установке и запуску Elastcisearch.
составьте Dockerfile-манифест для elasticsearch
```
student@student-virtual-machine:~/docker/elasticsearch$ nano dockerfile
---------------------------------------------------------------------------
FROM centos:7
ENV PATH=/usr/lib:$PATH

RUN yum install wget -y

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.0-linux-x86_64.tar.gz
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.0-linux-x86_64.tar.gz.sha512
RUN yum install perl-Digest-SHA -y
RUN shasum -a 512 -c elasticsearch-8.1.0-linux-x86_64.tar.gz.sha512
RUN tar -xzf elasticsearch-8.1.0-linux-x86_64.tar.gz

ADD elasticsearch.yml /elasticsearch-8.1.0/config/
ENV ES_HOME=/elasticsearch-8.1.0
RUN groupadd elastic
RUN useradd -g elastic elastic

RUN mkdir /var/lib/logs
RUN chown elastic:elastic /var/lib/logs
RUN mkdir /var/lib/data
RUN chown elastic:elastic /var/lib/data
RUN chown -R elastic:elastic /elasticsearch-8.1.0/

USER elastic
CMD ["/usr/sbin/init"]
CMD ["/elasticsearch-8.1.0/bin/elasticsearch"]
---------------------------------------------------------------------------
student@student-virtual-machine:~/docker/elasticsearch$ nano elasticsearch.yml
--------------------------------------------------------------------------- 
cluster.name: netology_test
discovery.type: single-node
path.data: /var/lib/data
path.logs: /var/lib/logs
network.host: 0.0.0.0
discovery.seed_hosts: ["127.0.0.1", "[::1"]
xpack.security.enabled: false
----------------------------------------------------------------------------
```
соберите docker-образ и сделайте push в ваш docker.io репозиторий
```
student@student-virtual-machine:~/docker/elasticsearch$ docker build -t study_elastic .
student@student-virtual-machine:~$ docker login
student@student-virtual-machine:~$ docker tag study_elastic:latest evgennetology2022/homework
student@student-virtual-machine:~$ docker push evgennetology2022/homework
Using default tag: latest
The push refers to repository [docker.io/evgennetology2022/homework]
4cd216ab6414: Pushed 
7d3ef7c10dfe: Pushed 
58f119ba88d2: Pushed 
f212cd83a000: Pushed 
39c253b5157c: Pushed 
c76aa9eb0b6b: Pushed 
f27c6f79273e: Pushed 
4c44a8dc3245: Pushed 
94e74d25d23f: Pushed 
c2b68ca3036b: Pushed 
8683295fd72e: Pushed 
e29e90de9a2a: Pushed 
fb505b2650ea: Pushed 
174f56854903: Mounted from library/centos 
latest: digest: sha256:96afbc6cc180fee8c9a1347cf4d4ee2a8a553c47f8a28d30bb4e410b1710d4ea size: 3250

https://hub.docker.com/layers/197910812/evgennetology2022/homework/latest/images/sha256-96afbc6cc180fee8c9a1347cf4d4ee2a8a553c47f8a28d30bb4e410b1710d4ea?context=repo
```
ответ elasticsearch на запрос пути / в json виде
```
student@student-virtual-machine:~$ curl localhost:9200 /
{
  "name" : "5461c3c6ac24",
  "cluster_name" : "netology_test",
  "cluster_uuid" : "uAJWm9iMReyHiGypP6OU8A",
  "version" : {
    "number" : "8.1.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "3700f7679f7d95e36da0b43762189bab189bc53a",
    "build_date" : "2022-03-03T14:20:00.690422633Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
curl: (3) URL using bad/illegal format or missing URL
```

## Обязательная задача 2

Ознакомтесь с документацией и добавьте в elasticsearch 3 индекса, в соответствии со таблицей:
```
student@student-virtual-machine:~$ curl -X PUT 'localhost:9200/ind-1' -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1, "number_of_replicas": 0}}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}
student@student-virtual-machine:~$ curl -X PUT 'localhost:9200/ind-2' -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2, "number_of_replicas": 1}}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}
student@student-virtual-machine:~$ curl -X PUT 'localhost:9200/ind-3' -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4, "number_of_replicas": 2}}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}
```
Получите список индексов и их статусов, используя API и приведите в ответе на задание.
```
student@student-virtual-machine:~$ curl -X GET 'localhost:9200/_cat/indices?v'
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 uJ355c-aRcezsZUq77JtIw   1   0          0            0       225b           225b
yellow open   ind-3 EsCsiX8ESsKOHiCpjIG34A   4   2          0            0       900b           900b
yellow open   ind-2 tAp9hD-ASxCVgaQ3sosgWg   2   1          0            0       450b           450b
student@student-virtual-machine:~$ curl -X GET http://localhost:9200/ind-1?pretty=true
{
  "ind-1" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "ind-1",
        "creation_date" : "1647525274897",
        "number_of_replicas" : "0",
        "uuid" : "uJ355c-aRcezsZUq77JtIw",
        "version" : {
          "created" : "8010099"
        }
      }
    }
  }
}
student@student-virtual-machine:~$ curl -X GET http://localhost:9200/ind-2?pretty=true
{
  "ind-2" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "2",
        "provided_name" : "ind-2",
        "creation_date" : "1647525327151",
        "number_of_replicas" : "1",
        "uuid" : "tAp9hD-ASxCVgaQ3sosgWg",
        "version" : {
          "created" : "8010099"
        }
      }
    }
  }
}
student@student-virtual-machine:~$ curl -X GET http://localhost:9200/ind-3?pretty=true
{
  "ind-3" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "4",
        "provided_name" : "ind-3",
        "creation_date" : "1647525388239",
        "number_of_replicas" : "2",
        "uuid" : "EsCsiX8ESsKOHiCpjIG34A",
        "version" : {
          "created" : "8010099"
        }
      }
    }
  }
}
```
Получите состояние кластера elasticsearch, используя API.
```
student@student-virtual-machine:~$ curl -X GET http://localhost:9200/_cluster/health?pretty=true
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```
Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
```
Статус кластера "yellow" - потому как отсутсвуют другие ноды для репликации. Для индексов, "yellow" те, у кого указано количество реплик, но по факту реплик нету.
```
Удалите все индексы.
```
student@student-virtual-machine:~$ curl -X DELETE http://localhost:9200/ind-1?pretty=true
{
  "acknowledged" : true
}
student@student-virtual-machine:~$ curl -X DELETE http://localhost:9200/ind-2?pretty=true
{
  "acknowledged" : true
}
student@student-virtual-machine:~$ curl -X DELETE http://localhost:9200/ind-3?pretty=true
{
  "acknowledged" : true
}
student@student-virtual-machine:~$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index uuid pri rep docs.count docs.deleted store.size pri.store.size
```

## Обязательная задача 3

Создайте директорию {путь до корневой директории с elasticsearch в образе}/snapshots.
```
student@student-virtual-machine:~$ docker ps
CONTAINER ID   IMAGE           COMMAND                  CREATED        STATUS        PORTS                                       NAMES
5461c3c6ac24   study_elastic   "/elasticsearch-8.1.…"   46 hours ago   Up 46 hours   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp   modest_matsumoto
student@student-virtual-machine:~$ docker exec -it modest_matsumoto /bin/bash 
[elastic@5461c3c6ac24 /]$ mkdir /elasticsearch-8.1.0/snapshots
[elastic@5461c3c6ac24 /]$ ls /elasticsearch-8.1.0
LICENSE.txt  NOTICE.txt  README.asciidoc  bin  config  jdk  lib  logs  modules  plugins  snapshots
[elastic@5461c3c6ac24 /]$ chown elastic:elastic /elasticsearch-8.1.0/snapshots 
[elastic@5461c3c6ac24 /]$ vi /elasticsearch-8.1.0/config/elasticsearch.yml 
------------------------------------------------------------
path.repo: /elasticsearch-8.1.0/snapshots
------------------------------------------------------------
[elastic@5461c3c6ac24 /]$ exit

```
Используя API зарегистрируйте данную директорию как snapshot repository c именем netology_backup.
```
student@student-virtual-machine:~$ docker restart modest_matsumoto 
modest_matsumoto
student@student-virtual-machine:~$ docker ps
CONTAINER ID   IMAGE           COMMAND                  CREATED      STATUS         PORTS                                       NAMES
5461c3c6ac24   study_elastic   "/elasticsearch-8.1.…"   2 days ago   Up 4 seconds   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp   modest_matsumoto
student@student-virtual-machine:~$ curl -X PUT localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/elasticsearch-8.1.0/snapshots/netology_backup" }}'
{
  "acknowledged" : true
}
student@student-virtual-machine:~$ curl -X GET localhost:9200/_snapshot/netology_backup?pretty
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/elasticsearch-8.1.0/snapshots/netology_backup"
    }
  }
}

```
Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.
```
student@student-virtual-machine:~$ curl -X PUT 'localhost:9200/ind-test' -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1, "number_of_replicas": 0}}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-test"}
student@student-virtual-machine:~$ curl -X GET 'localhost:9200/_cat/indices?v'
health status index    uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-test CEE-8iOaRDCqeKCFVAaYdA   1   0          0            0       225b           225b
```
Создайте snapshot состояния кластера elasticsearch.
```
student@student-virtual-machine:~$ curl -X PUT localhost:9200/_snapshot/netology_backup/1sn?pretty
{
  "accepted" : true
}
student@student-virtual-machine:~$ docker exec modest_matsumoto ls /elasticsearch-8.1.0/snapshots/netology_backup
index-0
index.latest
indices
meta-UX5z8MBNReSi4pIN-9ngpQ.dat
snap-UX5z8MBNReSi4pIN-9ngpQ.dat
```
Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.
```
student@student-virtual-machine:~$ curl -X DELETE http://localhost:9200/ind-test?pretty=true
{
  "acknowledged" : true
}
student@student-virtual-machine:~$ curl -X PUT 'localhost:9200/ind-test2?pretty=true' -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1, "number_of_replicas": 0}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-test2"
}student@student-virtual-machine:~$ curl -X GET 'localhost:9200/_cat/indices?v'
health status index     uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-test2 HmIxpPnNTAyWJr4kNmqtCg   1   0          0            0       225b           225b
```
Восстановите состояние кластера elasticsearch из snapshot, созданного ранее.
```
student@student-virtual-machine:~$ curl -X POST localhost:9200/_snapshot/netology_backup/1sn/_restore?pretty=true
{
  "accepted" : true
}
student@student-virtual-machine:~$ curl -X GET 'localhost:9200/_cat/indices?v'
health status index     uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-test2 HmIxpPnNTAyWJr4kNmqtCg   1   0          0            0       225b           225b
green  open   ind-test  Jf61K7JSTFSV8sqUHinwmA   1   0          0            0       225b           225b

