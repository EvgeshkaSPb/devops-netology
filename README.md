# Домашнее задание к занятию "6.3. MySQL


## Обязательная задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
```
docker-compose.yml
version: '3.1'

services:

  db:
    image: mysql:8.0
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: db
    volumes:
      - ~/docker/mysql_vol:/var/lib/mysql
    ports:
      - 3306:3306

student@student-virtual-machine:~/docker$ docker exec -it docker_db_1 /bin/bash
root@b7d8fc11445f:/# mysqldump -u root -p db > /var/lib/mysql/db.sql
Enter password: 
root@b7d8fc11445f:/# exit
exit
student@student-virtual-machine:~/docker$ ls mysql_vol/
 auto.cnf        binlog.index      client-key.pem      '#ib_16384_1.dblwr'   ib_logfile1     mysql.ibd            server-cert.pem   undo_002
 binlog.000001   ca-key.pem        db                   ib_buffer_pool       ibtmp1          performance_schema   server-key.pem
 binlog.000002   ca.pem            db.sql               ibdata1             '#innodb_temp'   private_key.pem      sys
 binlog.000003   client-cert.pem  '#ib_16384_0.dblwr'   ib_logfile0          mysql           public_key.pem       undo_001
```
Изучите бэкап БД и восстановитесь из него.
```
student@student-virtual-machine:~/docker$ cp test_dump.sql mysql_vol/test_dump.sql
student@student-virtual-machine:~/docker$ docker exec -it docker_db_1 /bin/bash
root@b7d8fc11445f:/# mysql -u root -p db < /var/lib/mysql/test_dump.sql
root@b7d8fc11445f:/# mysql -u root -p
```
Используя команду \h получите список управляющих команд.
```
mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.
```
Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.
```
mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		26
Current database:	
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.28 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			1 hour 3 min 16 sec

Threads: 2  Questions: 130  Slow queries: 0  Opens: 233  Flush tables: 3  Open tables: 150  Queries per second avg: 0.034
```
Подключитесь к восстановленной БД и получите список таблиц из этой БД.
```
mysql> use db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+--------------+
| Tables_in_db |
+--------------+
| orders       |
+--------------+
1 row in set (0.00 sec)
```
Приведите в ответе количество записей с price > 300.
```
mysql> select count(*) from orders where price > 300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```

## Обязательная задача 2

Создайте пользователя test в БД c паролем test-pass, используя:

плагин авторизации mysql_native_password
срок истечения пароля - 180 дней
количество попыток авторизации - 3
максимальное количество запросов в час - 100
аттрибуты пользователя:
Фамилия "Pretty"
Имя "James"
```
CREATE user 'test'@'localhost' 
IDENTIFIED WITH mysql_native_password by 'test-pass'
PASSWORD EXPIRE INTERVAL 180 DAY
FAILED_LOGIN_ATTEMPTS 3
ATTRIBUTE '{"surname": "Pretty", "name": "James"}';
ALTER user 'test'@'localhost'
with MAX_QUERIES_PER_HOUR 100;
```
Предоставьте привелегии пользователю test на операции SELECT базы test_db.
```
grant SELECT on db.* to 'test'@'localhost';
```
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.
```
mysql> SELECT * from information_schema.USER_ATTRIBUTES WHERE `USER` = 'test';
+------+-----------+----------------------------------------+
| USER | HOST      | ATTRIBUTE                              |
+------+-----------+----------------------------------------+
| test | localhost | {"name": "James", "surname": "Pretty"} |
+------+-----------+----------------------------------------+
1 row in set (0.01 sec)
```

## Обязательная задача 3

Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;
```
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)
mysql> show profiles;
+----------+------------+-------------------+
| Query_ID | Duration   | Query             |
+----------+------------+-------------------+
|        1 | 0.00024700 | SET profiling = 1 |
+----------+------------+-------------------+
```
Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.
```
mysql> SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA='db'AND TABLE_NAME='orders';
+--------+
| ENGINE |
+--------+
| InnoDB |
+--------+
1 row in set (0.00 sec)
```
Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:
на MyISAM
на InnoDB
```
mysql> ALTER TABLE orders ENGINE=MyISAM;
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA='db'AND TABLE_NAME='orders';
+--------+
| ENGINE |
+--------+
| MyISAM |
+--------+
1 row in set (0.00 sec)

mysql> ALTER TABLE orders ENGINE=InnoDB;
Query OK, 5 rows affected (0.00 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA='db'AND TABLE_NAME='orders';
+--------+
| ENGINE |
+--------+
| InnoDB |
+--------+
1 row in set (0.00 sec)
mysql> show profiles;
+----------+------------+---------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                       |
+----------+------------+---------------------------------------------------------------------------------------------+
|        1 | 0.00024700 | SET profiling = 1                                                                           |
|        2 | 0.00021200 | SET profiling = 1                                                                           |
|        3 | 0.00016800 | show engine                                                                                 |
|        4 | 0.00038275 | show engines                                                                                |
|        5 | 0.00101750 | show table status where name = 'orders'                                                     |
|        6 | 0.00018475 | show table status where name = 'orders' filter by 'Engine'                                  |
|        7 | 0.00225750 | SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA='db'AND TABLE_NAME='orders' |
|        8 | 0.01177775 | ALTER TABLE orders ENGINE=MyISAM                                                            |
|        9 | 0.00207350 | SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA='db'AND TABLE_NAME='orders' |
|       10 | 0.00774675 | ALTER TABLE orders ENGINE=InnoDB                                                            |
|       11 | 0.00084075 | SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA='db'AND TABLE_NAME='orders' |
+----------+------------+---------------------------------------------------------------------------------------------+
11 rows in set, 1 warning (0.00 sec)
```
## Обязательная задача 4

Изучите файл my.cnf в директории /etc/mysql. Измените его согласно ТЗ (движок InnoDB):
```
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL
innodb_flush_log_at_trx_commit = 0
innodb_file_format=Barracuda
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 579M
max_binlog_size = 100M
```




