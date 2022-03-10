# Домашнее задание к занятию "6.4. PostgreSQL"


## Обязательная задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
```
GNU nano 4.8                                                               docker-compose.yml                                                                         
version: '3.8'
services:
  postgre13:
    image: postgres:13
    restart: always
    environment:
      - POSTGRES_PASSWORD=student
      - POSTGRES_USER=student
    volumes:
      - ~/docker/psql_vol:/var/lib/postgresql/data
    ports:
      - '5432:5432'
```

Подключитесь к БД PostgreSQL используя psql.
Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.
```
tudent@student-virtual-machine:~/docker$ psql -h 127.0.0.1 -U student -d student
Password for user student: 
psql (12.9 (Ubuntu 12.9-0ubuntu0.20.04.1), server 13.6 (Debian 13.6-1.pgdg110+1))
WARNING: psql major version 12, server major version 13.
         Some psql features might not work.
Type "help" for help.

student=# \?
----------------------------------------
```
вывода списка БД
```
student=# \l
                               List of databases
   Name    |  Owner  | Encoding |  Collate   |   Ctype    |  Access privileges  
-----------+---------+----------+------------+------------+---------------------
 postgres  | student | UTF8     | en_US.utf8 | en_US.utf8 | 
 student   | student | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | student | UTF8     | en_US.utf8 | en_US.utf8 | =c/student         +
           |         |          |            |            | student=CTc/student
 template1 | student | UTF8     | en_US.utf8 | en_US.utf8 | =c/student         +
           |         |          |            |            | student=CTc/student
(4 rows)
```
подключения к БД
```
student=# \c student 
psql (12.9 (Ubuntu 12.9-0ubuntu0.20.04.1), server 13.6 (Debian 13.6-1.pgdg110+1))
WARNING: psql major version 12, server major version 13.
         Some psql features might not work.
You are now connected to database "student" as user "student".
```
вывода списка таблиц
```
# Для вывода примера, создал в БД student таблицу orders (дз 6.2).
student=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner  
--------+--------+-------+---------
 public | orders | table | student
(1 row)

```
вывода описания содержимого таблиц
```
student=# \d orders
                  Table "public.orders"
    Column    |  Type   | Collation | Nullable | Default 
--------------+---------+-----------+----------+---------
 id           | integer |           | not null | 
 наименование | text    |           |          | 
 цена         | integer |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)

```
выхода из psql
```
student=# \q
student@student-virtual-machine:~/docker$
```

## Обязательная задача 2

Используя psql создайте БД test_database.
```
student@student-virtual-machine:~/docker$ psql -h 127.0.0.1 -U student -d student
Password for user student: 
psql (12.9 (Ubuntu 12.9-0ubuntu0.20.04.1), server 13.6 (Debian 13.6-1.pgdg110+1))
WARNING: psql major version 12, server major version 13.
         Some psql features might not work.
Type "help" for help.

student=# create database test_database;
CREATE DATABASE
student=# \l
                                 List of databases
     Name      |  Owner  | Encoding |  Collate   |   Ctype    |  Access privileges  
---------------+---------+----------+------------+------------+---------------------
 postgres      | student | UTF8     | en_US.utf8 | en_US.utf8 | 
 student       | student | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0     | student | UTF8     | en_US.utf8 | en_US.utf8 | =c/student         +
               |         |          |            |            | student=CTc/student
 template1     | student | UTF8     | en_US.utf8 | en_US.utf8 | =c/student         +
               |         |          |            |            | student=CTc/student
 test_database | student | UTF8     | en_US.utf8 | en_US.utf8 | 
```
Восстановите бэкап БД в test_database.
```
student@student-virtual-machine:~/docker$ docker exec -it docker_postgre13_1 /bin/bash
root@5c02333a5c6b:/# psql -U student test_database < /var/lib/postgresql/data/test_dump.sql 
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ERROR:  role "postgres" does not exist
CREATE SEQUENCE
ERROR:  role "postgres" does not exist
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE
```
Перейдите в управляющую консоль psql внутри контейнера.
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
```
root@5c02333a5c6b:/# psql -U student
psql (13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.

student=# \c test_database
You are now connected to database "test_database" as user "student".
test_database-# \dt
         List of relations
 Schema |  Name  | Type  |  Owner  
--------+--------+-------+---------
 public | orders | table | student
(1 row)
test_database=# ANALYZE VERBOSE public.orders ;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```
Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
```
test_database=# select max(avg_width) from pg_stats where tablename= 'orders' ;
 max 
-----
  16
(1 row)
```

## Обязательная задача 3
Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. 
Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).
Предложите SQL-транзакцию для проведения данной операции.
```
#Вариант 1 - простое разбиение по диапазонам.
create table orders_2 as select * from orders where (price <='499');
create table orders_1 as select * from orders where (price >'499');
#Вариант -2 Разделим таблицу через декларативное секционирование.
alter table orders rename to old_orders;
create table orders (id integer, title varchar(80), price integer) partition by range(price);
create table orders_under499 partition of orders for values from ('0') to ('499');
create table orders_over499 partition of orders for values from ('499') to (maxvalue);
insert into orders select * from old_orders ;
#Таблицу возможно было разделить при проектировании, использовав "варинант 2" или задейстовав механизм наследования (INHERITS).
```
## Обязательная задача 4
Используя утилиту pg_dump создайте бекап БД test_database.
```
root@5c02333a5c6b:/# pg_dump -U student -d test_database > /var/lib/postgresql/data/test_database.sql
```
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?
```
alter table orders add constraint title_unique unique (title);
```
