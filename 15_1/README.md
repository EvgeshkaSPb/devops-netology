# Домашнее задание к занятию "15.1. Организация сети"

Домашнее задание будет состоять из обязательной части, которую необходимо выполнить на провайдере Яндекс.Облако и дополнительной части в AWS по желанию. Все домашние задания в 15 блоке связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
Все задания требуется выполнить с помощью Terraform, результатом выполненного домашнего задания будет код в репозитории. 

Перед началом работ следует настроить доступ до облачных ресурсов из Terraform используя материалы прошлых лекций и [ДЗ](https://github.com/netology-code/virt-homeworks/tree/master/07-terraform-02-syntax ). А также заранее выбрать регион (в случае AWS) и зону.

---
## Задание 1. Яндекс.Облако (обязательное к выполнению)

1. Создать VPC.
- Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.
- Создать в vpc subnet с названием public, сетью 192.168.10.0/24.
- Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1
- Создать в этой публичной подсети виртуалку с публичным IP и подключиться к ней, убедиться что есть доступ к интернету.
3. Приватная подсеть.
- Создать в vpc subnet с названием private, сетью 192.168.20.0/24.
- Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс
- Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее и убедиться что есть доступ к интернету

Resource terraform для ЯО
- [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet)
- [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table)
- [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance)

## Решение

В рамках выполнения задания были созданы файлы конфигурации terraform:  
* [variables.tf](https://github.com/EvgeshkaSPb/devops-netology/blob/main/15_1/config/variables.tf) - блок переменных  
* [provider.tf](https://github.com/EvgeshkaSPb/devops-netology/blob/main/15_1/config/provider.tf)  - настройки Yandex Cloud  
* [instances.tf](https://github.com/EvgeshkaSPb/devops-netology/blob/main/15_1/config/instances.tf) - настройки ВМ  
* [network.tf](https://github.com/EvgeshkaSPb/devops-netology/blob/main/15_1/config/network.tf) - настройки сети  

Сгенерированы ssh ключи  

```
student@student-virtual-machine:~/15/15_1$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/student/.ssh/id_rsa): ./id_rsa_hw
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in ./id_rsa_hw
Your public key has been saved in ./id_rsa_hw.pub
The key fingerprint is:
SHA256:jH8ayWzlcY1A29J9HwOl6Ief2Ali3edDjhqWxgxi73Y student@student-virtual-machine
The key's randomart image is:
+---[RSA 3072]----+
|          .  ... |
|         . +..o  |
|          +.o..o.|
|       o  oooo .+|
|      .oS+o=oo.o.|
|      .+++=oB O  |
|        B.oO * + |
|       ..=oEo   .|
|        o...     |
+----[SHA256]-----+
```

### Выплнение

Применяем конфигурацию terraform
<details>
<summary>Вывод консоли terraform apply </summary>

```
student@student-virtual-machine:~/15/15_1$ terraform apply
data.yandex_compute_image.ubuntu-2004: Reading...
data.yandex_compute_image.nat-ubuntu: Reading...
data.yandex_compute_image.nat-ubuntu: Read complete after 0s [id=fd8o8aph4t4pdisf1fio]
data.yandex_compute_image.ubuntu-2004: Read complete after 0s [id=fd8tckeqoshi403tks4l]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.private_instance will be created
  + resource "yandex_compute_instance" "private_instance" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = "ubuntu-private.local"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9JWwCz1bKyID6fhX21of9wtM7jGjW7rFP7jqMjBHjry0y8C9O+cKUohpAezZSnAIo3bM4oLjkBZvf4XmNZrS1HoVDrr7jXmnAbbHnuRDkykA7oxi5tKMFoWpLypb5qXK5FakWrf4lAqFfWaNW6VuTOdXqTYp9i+vVx2BfXSnsi8IbudtDUp3PWJzdwVpCv//0zNNrkxkTokBpOYDVempjt0eOa82tKjQr1iBUWZ2DS5bvaveLU8BuL8zTkP+Y8Yk6RIWsPMnFR5JZUssHal7NpGpR2bFfQXguSvSqrqcGwLRfu4wd5l/ZhxOoBaElfy3JcPPqoFOReOCW8Pkyt+OJpVOli7/fNdy6uSccGr6Oc9QzcvxyMMd4SzjjVuoO8v60sB/pP7rzjIBeliIB+TKpkCTMCCqVK9naVjdWQmWECwiRarizmmMCeMWKzRGDZdmvI+PfWMFjnQVOgoGQ3kr2dtx3JvyEAX0zUNKl/eprSk7vHKh5xAiN4j/MfrHxd0s= student@student-virtual-machine
            EOT
        }
      + name                      = "ubuntu-private"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8tckeqoshi403tks4l"
              + name        = (known after apply)
              + size        = 50
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = false
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }
    }

  # yandex_compute_instance.public_instance will be created
  + resource "yandex_compute_instance" "public_instance" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = "ubuntu-public.local"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9JWwCz1bKyID6fhX21of9wtM7jGjW7rFP7jqMjBHjry0y8C9O+cKUohpAezZSnAIo3bM4oLjkBZvf4XmNZrS1HoVDrr7jXmnAbbHnuRDkykA7oxi5tKMFoWpLypb5qXK5FakWrf4lAqFfWaNW6VuTOdXqTYp9i+vVx2BfXSnsi8IbudtDUp3PWJzdwVpCv//0zNNrkxkTokBpOYDVempjt0eOa82tKjQr1iBUWZ2DS5bvaveLU8BuL8zTkP+Y8Yk6RIWsPMnFR5JZUssHal7NpGpR2bFfQXguSvSqrqcGwLRfu4wd5l/ZhxOoBaElfy3JcPPqoFOReOCW8Pkyt+OJpVOli7/fNdy6uSccGr6Oc9QzcvxyMMd4SzjjVuoO8v60sB/pP7rzjIBeliIB+TKpkCTMCCqVK9naVjdWQmWECwiRarizmmMCeMWKzRGDZdmvI+PfWMFjnQVOgoGQ3kr2dtx3JvyEAX0zUNKl/eprSk7vHKh5xAiN4j/MfrHxd0s= student@student-virtual-machine
            EOT
        }
      + name                      = "ubuntu-public"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8o8aph4t4pdisf1fio"
              + name        = (known after apply)
              + size        = 50
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = false
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }
    }

  # yandex_vpc_network.network will be created
  + resource "yandex_vpc_network" "network" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "homework"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_route_table.private_to_public will be created
  + resource "yandex_vpc_route_table" "private_to_public" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "private to public"
      + network_id = (known after apply)

      + static_route {
          + destination_prefix = "0.0.0.0/0"
          + next_hop_address   = (known after apply)
        }
    }

  # yandex_vpc_subnet.private will be created
  + resource "yandex_vpc_subnet" "private" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "private"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.20.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = (known after apply)
    }

  # yandex_vpc_subnet.public will be created
  + resource "yandex_vpc_subnet" "public" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "public"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = (known after apply)
    }

Plan: 6 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_vpc_network.network: Creating...
yandex_vpc_network.network: Creation complete after 1s [id=enpibmp1fee2lp84b2qq]
yandex_vpc_subnet.public: Creating...
yandex_vpc_subnet.public: Creation complete after 1s [id=b0cc3ekkbo89uughep8d]
yandex_compute_instance.public_instance: Creating...
yandex_compute_instance.public_instance: Still creating... [10s elapsed]
yandex_compute_instance.public_instance: Still creating... [20s elapsed]
yandex_compute_instance.public_instance: Creation complete after 29s [id=ef343euunst5selb03p6]
yandex_vpc_route_table.private_to_public: Creating...
yandex_vpc_route_table.private_to_public: Creation complete after 1s [id=enp00dhbubgcga6mfe9b]
yandex_vpc_subnet.private: Creating...
yandex_vpc_subnet.private: Creation complete after 1s [id=b0c4aivn75cq55n045nd]
yandex_compute_instance.private_instance: Creating...
yandex_compute_instance.private_instance: Still creating... [10s elapsed]
yandex_compute_instance.private_instance: Still creating... [20s elapsed]
yandex_compute_instance.private_instance: Creation complete after 29s [id=ef3d78d3eaea3a9io9cn]

Apply complete! Resources: 6 added, 0 changed, 0 destroyed.
```
</details>

### Проверка результатов

Смотрим созданные ресурсы
```
student@student-virtual-machine:~/15/15_1$ yc compute instance list
+----------------------+----------------+---------------+---------+---------------+---------------+
|          ID          |      NAME      |    ZONE ID    | STATUS  |  EXTERNAL IP  |  INTERNAL IP  |
+----------------------+----------------+---------------+---------+---------------+---------------+
| ef343euunst5selb03p6 | ubuntu-public  | ru-central1-c | RUNNING | 51.250.46.226 | 192.168.10.28 |
| ef3d78d3eaea3a9io9cn | ubuntu-private | ru-central1-c | RUNNING |               | 192.168.20.20 |
+----------------------+----------------+---------------+---------+---------------+---------------+
student@student-virtual-machine:~/15/15_1$ yc vpc network list
+----------------------+----------+
|          ID          |   NAME   |
+----------------------+----------+
| enpibmp1fee2lp84b2qq | homework |
+----------------------+----------+
student@student-virtual-machine:~/15/15_1$ yc vpc subnet list
+----------------------+---------+----------------------+----------------------+---------------+-------------------+
|          ID          |  NAME   |      NETWORK ID      |    ROUTE TABLE ID    |     ZONE      |       RANGE       |
+----------------------+---------+----------------------+----------------------+---------------+-------------------+
| b0c4aivn75cq55n045nd | private | enpibmp1fee2lp84b2qq | enp00dhbubgcga6mfe9b | ru-central1-c | [192.168.20.0/24] |
| b0cc3ekkbo89uughep8d | public  | enpibmp1fee2lp84b2qq |                      | ru-central1-c | [192.168.10.0/24] |
+----------------------+---------+----------------------+----------------------+---------------+-------------------+
student@student-virtual-machine:~/15/15_1$ yc vpc route-table get enp00dhbubgcga6mfe9b
id: enp00dhbubgcga6mfe9b
folder_id: b1g7042ebain0i1ptpvd
created_at: "2023-04-07T16:43:21Z"
name: private to public
network_id: enpibmp1fee2lp84b2qq
static_routes:
  - destination_prefix: 0.0.0.0/0
    next_hop_address: 192.168.10.28
```
Подключаемся к ВМ

```
student@student-virtual-machine:~/15/15_1$ scp -i id_rsa_hw id_rsa_hw ubuntu@51.250.46.226:/home/ubuntu/.ssh/
id_rsa_hw                                                                                                                              100% 2622   128.1KB/s   00:00    
student@student-virtual-machine:~/15/15_1$ ssh -i id_rsa_hw ubuntu@51.250.46.226
Welcome to Ubuntu 18.04.6 LTS (GNU/Linux 4.15.0-112-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '20.04.6 LTS' available.
Run 'do-release-upgrade' to upgrade to it.



#################################################################
This instance runs Yandex.Cloud Marketplace product
Please wait while we configure your product...

Documentation for Yandex Cloud Marketplace images available at https://cloud.yandex.ru/docs

#################################################################

Last login: Fri Apr  7 17:03:39 2023 from 95.216.43.199
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.
ubuntu@ubuntu-public:~$ ssh -i .ssh/id_rsa_hw ubuntu@192.168.20.20
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-146-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

 * Introducing Expanded Security Maintenance for Applications.
   Receive updates to over 25,000 software packages with your
   Ubuntu Pro subscription. Free for personal use.

     https://ubuntu.com/pro

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.
ubuntu@ubuntu-private:~$ 
```

### Проверяем хождение траффика

Запускаем ping на private
```
ubuntu@ubuntu-private:~$ ping ya.ru -c 15
PING ya.ru (5.255.255.242) 56(84) bytes of data.
64 bytes from ya.ru (5.255.255.242): icmp_seq=1 ttl=57 time=4.37 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=2 ttl=57 time=4.21 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=3 ttl=57 time=4.16 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=4 ttl=57 time=4.29 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=5 ttl=57 time=4.22 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=6 ttl=57 time=4.18 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=7 ttl=57 time=4.71 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=8 ttl=57 time=4.57 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=9 ttl=57 time=4.46 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=10 ttl=57 time=4.19 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=11 ttl=57 time=4.28 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=12 ttl=57 time=4.16 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=13 ttl=57 time=4.21 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=14 ttl=57 time=4.16 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=15 ttl=57 time=4.14 ms

--- ya.ru ping statistics ---
15 packets transmitted, 15 received, 0% packet loss, time 14021ms
rtt min/avg/max/mdev = 4.142/4.285/4.707/0.164 ms
ubuntu@ubuntu-private:~$ 
```
Снимаем tcpdump на public
```
ubuntu@ubuntu-public:~$ sudo tcpdump -nni any net 192.168.20.0/24 and port ! 22 -c 5
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on any, link-type LINUX_SLL (Linux cooked), capture size 262144 bytes
17:48:04.841794 IP 192.168.20.20 > 5.255.255.242: ICMP echo request, id 6, seq 7, length 64
17:48:04.845808 IP 5.255.255.242 > 192.168.20.20: ICMP echo reply, id 6, seq 7, length 64
17:48:05.843652 IP 192.168.20.20 > 5.255.255.242: ICMP echo request, id 6, seq 8, length 64
17:48:05.847523 IP 5.255.255.242 > 192.168.20.20: ICMP echo reply, id 6, seq 8, length 64
17:48:06.845490 IP 192.168.20.20 > 5.255.255.242: ICMP echo request, id 6, seq 9, length 64
5 packets captured
5 packets received by filter
0 packets dropped by kernel
```

## Задание 2*. AWS (необязательное к выполнению)

1. Создать VPC.
- Cоздать пустую VPC с подсетью 10.10.0.0/16.
2. Публичная подсеть.
- Создать в vpc subnet с названием public, сетью 10.10.1.0/24
- Разрешить в данной subnet присвоение public IP по-умолчанию. 
- Создать Internet gateway 
- Добавить в таблицу маршрутизации маршрут, направляющий весь исходящий трафик в Internet gateway.
- Создать security group с разрешающими правилами на SSH и ICMP. Привязать данную security-group на все создаваемые в данном ДЗ виртуалки
- Создать в этой подсети виртуалку и убедиться, что инстанс имеет публичный IP. Подключиться к ней, убедиться что есть доступ к интернету.
- Добавить NAT gateway в public subnet.
3. Приватная подсеть.
- Создать в vpc subnet с названием private, сетью 10.10.2.0/24
- Создать отдельную таблицу маршрутизации и привязать ее к private-подсети
- Добавить Route, направляющий весь исходящий трафик private сети в NAT.
- Создать виртуалку в приватной сети.
- Подключиться к ней по SSH по приватному IP через виртуалку, созданную ранее в публичной подсети и убедиться, что с виртуалки есть выход в интернет.

Resource terraform
- [VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- [Subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)
- [Internet Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)
