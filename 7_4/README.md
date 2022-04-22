# Домашнее задание к занятию "7.4. Средства командной работы над инфраструктурой."

## Задача 1. Задача 1. Настроить terraform cloud (необязательно, но крайне желательно).
```
https://ibb.co/XW9kBxw
```
## Задача 2. Написать серверный конфиг для атлантиса.
```
https://github.com/EvgeshkaSPb/devops-netology/blob/main/7_4/atlantis.yaml
https://github.com/EvgeshkaSPb/devops-netology/blob/main/7_4/server.yaml
```
### Задача 3. Знакомство с каталогом модулей.
В каталоге модулей найдите официальный модуль от aws для создания ec2 инстансов.
```
https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest
```
Изучите как устроен модуль. Задумайтесь, будете ли в своем проекте использовать этот модуль или непосредственно ресурс aws_instance без помощи модуля?
```
Как я понял.
Модуль, по сути своей представляет шаблон для "оптимизации" кода при создании инстансов в терраформ. В данный модуль просто набита куча свойств инстансов ec2, со своим блоком переменных.
Т.е. изменив начения в файле .terraform/modules/ec2_instance/variables.tf мы задаем необходимые нам параметры.
Использование самого модуля представляется мне сомнительным (разве что как пример значений) т.к. все равно необходимо разбираться что за значения в нем указаны и какие значения необходимо менять в каждом конкретном случае.
```
В рамках предпоследнего задания был создан ec2 при помощи ресурса aws_instance. Создайте аналогичный инстанс при помощи найденного модуля.
```
Логика задачи не понятна. В прошлом задании мы создавли пул разных инстансов в разных воркспейсах. Модуль же (в моем понимании) служит для шаблонизации и я не понимаю, надо ли его применить в данном случае?
Тем более в задаче указан инстанс в единственном числе.
Вставил значение в .terraform/modules/ec2_instance/variables.tf 
-------------------------------------------------------------------------------------------------------------------
variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = "ami-0d527b8c289b4af7f"
}
-------------------------------------------------------------------------------------------------------------------
```
Создал main на 3 однотипных инстанса в разных воркспейсах, если не прав - отправляйте на доработку с комментариями - что нужно делать.
````
student@student-virtual-machine:~/netology$ nano module/main.tf 
-----------------------------------------------------------------------------------------------------------------------------
provider "aws" {
    region = "eu-central-1"
}
 resource "aws_s3_bucket" "terraform_state" {
    bucket = "study-bucket-1-homework"
    versioning {
        enabled = true
    }

 }
 locals {
  count_vm = {
    stage = 1
    prod = 2
  }
 }

 module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  count = local.count_vm[terraform.workspace]
  name = "HW-${count.index+1}"
 }
-------------------------------------------------------------------------------------------------------------------------------
student@student-virtual-machine:~/netology/module$ terraform workspace select prod
Switched to workspace "prod".
student@student-virtual-machine:~/netology/module$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_s3_bucket.terraform_state will be created
  + resource "aws_s3_bucket" "terraform_state" {
      + acceleration_status         = (known after apply)
      + acl                         = "private"
      + arn                         = (known after apply)
      + bucket                      = "study-bucket-1-homework"
      + bucket_domain_name          = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + object_lock_enabled         = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags_all                    = (known after apply)
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + object_lock_configuration {
          + object_lock_enabled = (known after apply)

          + rule {
              + default_retention {
                  + days  = (known after apply)
                  + mode  = (known after apply)
                  + years = (known after apply)
                }
            }
        }

      + versioning {
          + enabled    = true
          + mfa_delete = false
        }
    }

  # module.ec2_instance[0].aws_instance.this[0] will be created
  + resource "aws_instance" "this" {
      + ami                                  = "ami-0d527b8c289b4af7f"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t3.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = false
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "HW-1"
        }
      + tags_all                             = {
          + "Name" = "HW-1"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + volume_tags                          = {
          + "Name" = "HW-1"
        }
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification {
          + capacity_reservation_preference = (known after apply)

          + capacity_reservation_target {
              + capacity_reservation_id = (known after apply)
            }
        }

      + credit_specification {}

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + enclave_options {
          + enabled = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = "enabled"
          + http_put_response_hop_limit = 1
          + http_tokens                 = "optional"
          + instance_metadata_tags      = "disabled"
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + timeouts {}
    }

  # module.ec2_instance[1].aws_instance.this[0] will be created
  + resource "aws_instance" "this" {
      + ami                                  = "ami-0d527b8c289b4af7f"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t3.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = false
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "HW-2"
        }
      + tags_all                             = {
          + "Name" = "HW-2"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + volume_tags                          = {
          + "Name" = "HW-2"
        }
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification {
          + capacity_reservation_preference = (known after apply)

          + capacity_reservation_target {
              + capacity_reservation_id = (known after apply)
            }
        }

      + credit_specification {}

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + enclave_options {
          + enabled = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = "enabled"
          + http_put_response_hop_limit = 1
          + http_tokens                 = "optional"
          + instance_metadata_tags      = "disabled"
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + timeouts {}
    }

Plan: 3 to add, 0 to change, 0 to destroy.
╷
│ Warning: Argument is deprecated
│ 
│   with aws_s3_bucket.terraform_state,
│   on main.tf line 4, in resource "aws_s3_bucket" "terraform_state":
│    4:  resource "aws_s3_bucket" "terraform_state" {
│ 
│ Use the aws_s3_bucket_versioning resource instead
│ 
│ (and one more similar warning elsewhere)

Файлы по адресу.
https://github.com/EvgeshkaSPb/devops-netology/tree/main/module
```
