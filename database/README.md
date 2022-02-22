# Домашнее задание к занятию "6.2. SQL"


## Обязательная задача 1
Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.
```
cd docker
mkdir vol1 vol2
nano docker-compose.yml
version: '3.8'
services:
  pg_db:
    image: postgres
    restart: always
    environment:
      - POSTGRES_PASSWORD=student
      - POSTGRES_USER=student
      - POSTGRES_DB=studentDB
    volumes:
      - /home/docker/vol1:/var/lib/postgresql/data1
      - /home/docker/vol2:/var/lib/postgresql/data2
    ports:
      - '5432:5432'
```
## Обязательная задача 2
В БД из задачи 1:

создайте пользователя test-admin-user и БД test_db
в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
создайте пользователя test-simple-user
предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
```
create database test_db;
create user "test-admin-user" with encrypted password 'password';
grant all privileges on database test_db to "test-admin-user";
create table orders (id int primary key, наименование text, цена int);
create table clients (id int, фамилия text, "страна проживания" text, заказ int, foreign key (заказ) references orders (id));
grant all privileges on table clients to "test-admin-user";
grant all privileges on table orders  to "test-admin-user";
create user "test-simple-user" with encrypted password 'password';
grant select, insert, update, delete on table clients to "test-simple-user";
grant select, insert, update, delete on table orders  to "test-simple-user";

Получаем итоговый список БД
student@student-virtual-machine:~/docker$ psql -h 127.0.0.1 -U student -d studentDB
Password for user student: 
psql (12.9 (Ubuntu 12.9-0ubuntu0.20.04.1), server 12.10 (Debian 12.10-1.pgdg110+1))
Type "help" for help.

studentDB-# \l
                               List of databases
   Name    |  Owner  | Encoding |  Collate   |   Ctype    |  Access privileges  
-----------+---------+----------+------------+------------+---------------------
 postgres  | student | UTF8     | en_US.utf8 | en_US.utf8 | 
 studentDB | student | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | student | UTF8     | en_US.utf8 | en_US.utf8 | =c/student         +
           |         |          |            |            | student=CTc/student
 template1 | student | UTF8     | en_US.utf8 | en_US.utf8 | =c/student         +
           |         |          |            |            | student=CTc/student
 test_db   | student | UTF8     | en_US.utf8 | en_US.utf8 | 
(5 rows)

Получаем описание таблиц
studentDB-# \c test_db
psql (12.9 (Ubuntu 12.9-0ubuntu0.20.04.1), server 12.10 (Debian 12.10-1.pgdg110+1))
You are now connected to database "test_db" as user "student".
test_db-# \d orders
                  Table "public.orders"
    Column    |  Type   | Collation | Nullable | Default 
--------------+---------+-----------+----------+---------
 id           | integer |           | not null | 
 наименование | text    |           |          | 
 цена         | integer |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db-# \d clients 
                    Table "public.clients"
      Column       |  Type   | Collation | Nullable | Default 
-------------------+---------+-----------+----------+---------
 id                | integer |           |          | 
 фамилия           | text    |           |          | 
 страна проживания | text    |           |          | 
 заказ             | integer |           |          | 
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
SELECT * FROM information_schema.role_table_grants where table_name in ('orders','clients');
список пользователей с правами над таблицами test_db
 grantor |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
---------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 student | student          | test_db       | public       | orders     | INSERT         | YES          | NO
 student | student          | test_db       | public       | orders     | SELECT         | YES          | YES
 student | student          | test_db       | public       | orders     | UPDATE         | YES          | NO
 student | student          | test_db       | public       | orders     | DELETE         | YES          | NO
 student | student          | test_db       | public       | orders     | TRUNCATE       | YES          | NO
 student | student          | test_db       | public       | orders     | REFERENCES     | YES          | NO
 student | student          | test_db       | public       | orders     | TRIGGER        | YES          | NO
 student | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 student | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 student | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 student | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 student | test-admin-user  | test_db       | public       | orders     | INSERT         | NO           | NO
 student | test-admin-user  | test_db       | public       | orders     | SELECT         | NO           | YES
 student | test-admin-user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 student | test-admin-user  | test_db       | public       | orders     | DELETE         | NO           | NO
 student | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 student | test-admin-user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 student | test-admin-user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 student | student          | test_db       | public       | clients    | INSERT         | YES          | NO
 student | student          | test_db       | public       | clients    | SELECT         | YES          | YES
 student | student          | test_db       | public       | clients    | UPDATE         | YES          | NO
 student | student          | test_db       | public       | clients    | DELETE         | YES          | NO
 student | student          | test_db       | public       | clients    | TRUNCATE       | YES          | NO
 student | student          | test_db       | public       | clients    | REFERENCES     | YES          | NO
 student | student          | test_db       | public       | clients    | TRIGGER        | YES          | NO
 student | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 student | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 student | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 student | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
 student | test-admin-user  | test_db       | public       | clients    | INSERT         | NO           | NO
 student | test-admin-user  | test_db       | public       | clients    | SELECT         | NO           | YES
 student | test-admin-user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 student | test-admin-user  | test_db       | public       | clients    | DELETE         | NO           | NO
 student | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 student | test-admin-user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 student | test-admin-user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
(36 rows)
```
## Обязательная задача 3
Используя SQL синтаксис - наполните таблицы следующими тестовыми данными.
Используя SQL синтаксис:

вычислите количество записей для каждой таблицы
приведите в ответе:
запросы
результаты их выполнения.
```
#Заполняем
insert into orders (id,наименование, цена) values ('1', 'Шоколад', '10'),('2', 'Принтер', '3000'),('3', 'Книга', '500'), ('4', 'Монитор', '7000'), ('5', 'Гитара', '4000');
#Смотрим результаты
test_db=# select * from orders;
 id | наименование | цена 
----+--------------+------
  1 | Шоколад      |   10
  2 | Принтер      | 3000
  3 | Книга        |  500
  4 | Монитор      | 7000
  5 | Гитара       | 4000
# Вычисляем количество записей
test_db=# select count(*) from orders;
 count 
-------
     5
(1 row)
#Заполняем
insert into clients (id, фамилия, "страна проживания") values ('1', 'Иванов Иван Иванович','USA'),('2','Петров Петр Петрович','Canada'),('3','Иоганн Себастьян Бах','Japan'),('4','Ронни Джеймс Дио','Russia'),('5','Ritchie Blackmore','Russia');
#Смотрим результаты
test_db=# select * from clients;
 id |       фамилия        | страна проживания | заказ 
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |      
  2 | Петров Петр Петрович | Canada            |      
  3 | Иоганн Себастьян Бах | Japan             |      
  4 | Ронни Джеймс Дио     | Russia            |      
  5 | Ritchie Blackmore    | Russia            |      
(5 rows)
# Вычисляем количество записей
test_db=# select count(*) from clients;
 count 
-------
     5
(1 row)
```
## Обязательная задача 4
Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.
Используя foreign keys свяжите записи из таблиц, согласно таблице:
Приведите SQL-запросы для выполнения данных операций.
Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
Подсказк - используйте директиву UPDATE.
```
update clients set заказ = '3' where id = '1';
update clients set заказ = '4' where id = '2';
update clients set заказ = '5' where id = '3';
test_db=# select * from clients c where заказ is not null ;
 id |       фамилия        | страна проживания | заказ 
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
```
## Обязательная задача 5
Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.
```
test_db=# explain select * from clients c where заказ is not null;
                         QUERY PLAN                          
-------------------------------------------------------------
 Seq Scan on clients c  (cost=0.00..18.10 rows=806 width=72)
   Filter: ("заказ" IS NOT NULL)
(2 rows)
EXPLAIN показывает план запроса. В данном случае запрос простой до безобразия и полезной информации мало.
Мы не получили резултат самого запроса - только план. 
Мы получили в верхней строке "стоимость" запроса, количество запланированных к прочтению строк и средний размер строки в байтах.
Вторая строка - информация о фильтре.
```
## Обязательная задача 
Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
Остановите контейнер с PostgreSQL (но не удаляйте volumes).
Поднимите новый пустой контейнер с PostgreSQL.
Восстановите БД test_db в новом контейнере.
Приведите список операций, который вы применяли для бэкапа данных и восстановления.
```
#Делаем бэкап и отклбчаем контейнер
student@student-virtual-machine:~$ docker exec -t docker_pg_db_1 pg_dump -U student test_db -f /var/lib/postgresql/data2/backup.sql
student@student-virtual-machine:~$ docker stop docker_pg_db_1 
docker_pg_db_1
student@student-virtual-machine:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
#Изменив yml запускаем новый контейнер
tudent@student-virtual-machine:~/docker$ docker-compose up --detach
WARNING: Found orphan containers (docker_pg_db_1) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.
Starting docker_postgre_1 ... done
student@student-virtual-machine:~/docker$ docker ps
CONTAINER ID   IMAGE      COMMAND                  CREATED          STATUS          PORTS                                       NAMES
908796249c3b   postgres   "docker-entrypoint.s…"   24 seconds ago   Up 10 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   docker_postgre_1
#Подключаемся к контейнеру и создаем пустую БД
student@student-virtual-machine:~/docker$ psql -h 127.0.0.1 -U student
Password for user student: 
psql (12.9 (Ubuntu 12.9-0ubuntu0.20.04.1), server 12.10 (Debian 12.10-1.pgdg110+1))
Type "help" for help.

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

student=# create database test_db;
CREATE DATABASE
student-# \q
#восстанавливаем бэкап
tudent@student-virtual-machine:~/docker$ docker exec -i docker_postgre_1 psql -U student -d test_db -f /var/lib/postgresql/data2/backup.sql
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
ALTER TABLE
CREATE TABLE
ALTER TABLE
COPY 5
COPY 5
ALTER TABLE
ALTER TABLE
psql:/var/lib/postgresql/data2/backup.sql:96: ERROR:  role "test-simple-user" does not exist
psql:/var/lib/postgresql/data2/backup.sql:97: ERROR:  role "test-admin-user" does not exist
psql:/var/lib/postgresql/data2/backup.sql:104: ERROR:  role "test-simple-user" does not exist
psql:/var/lib/postgresql/data2/backup.sql:105: ERROR:  role "test-admin-user" does not exist
# проверяем
student@student-virtual-machine:~/docker$ psql -h 127.0.0.1 -U student
Password for user student: 
psql (12.9 (Ubuntu 12.9-0ubuntu0.20.04.1), server 12.10 (Debian 12.10-1.pgdg110+1))
Type "help" for help.

student=# \c test_db 
psql (12.9 (Ubuntu 12.9-0ubuntu0.20.04.1), server 12.10 (Debian 12.10-1.pgdg110+1))
You are now connected to database "test_db" as user "student".
test_db=# \d
         List of relations
 Schema |  Name   | Type  |  Owner  
--------+---------+-------+---------
 public | clients | table | student
 public | orders  | table | student
(2 rows)
```
