# Домашнее задание к занятию "7.1. Инфраструктура как код"

## Обязательная задача 1. Выбор инструментов.
Через час совещание на котором менеджер расскажет о новом проекте. Начать работу над которым надо будет уже сегодня. На данный момент известно, что это будет сервис, который ваша компания будет предоставлять внешним заказчикам. 
Первое время, скорее всего, будет один внешний клиент, со временем внешних клиентов станет больше.
Так же по разговорам в компании есть вероятность, что техническое задание еще не четкое, что приведет к большому количеству небольших релизов, тестирований интеграций, откатов, доработок, то есть скучно не будет.
Для этого в рамках совещания надо будет выяснить подробности о проекте, что бы в итоге определиться с инструментами:
*
0.Если для ответа на эти вопросы недостаточно информации, то напишите какие моменты уточните на совещании.
```
Прежде чем отвечать на вопросы инструментов, необходимо уточнить - Будет ли организация использовать "облачные" сервисы в данном проекте. 
Будем считать, что ответ на данный вопрос положительный и основываться будем на облачной инфраструктуре.
```
1.Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый?
```
На старте проекта возможно применение изменяемого типа инфраструктуры т.к. планируется большой обем доработок и единственнный клиент, соответсвенно не нужно будет следить за единообразием большого количства машин.
Далее лучше использовать не изменяемый т.к. количество "активностей" в разработке уменьшиться, а количство клиентов и соответсвенно серверов увеличиться.
```
2.Будет ли центральный сервер для управления инфраструктурой?
```
С учетом использование облачной инфраструктуры нет необходимости использоваия центрального сервера. Его функции возьмет на себя провайдер.
```
3.Будут ли агенты на серверах?
```
Нет, ввиду отстувия центрального сервера для их конфигурирования.
```
4.Будут ли использованы средства для управления конфигурацией или инициализации ресурсов?
```
Конечно. На данный момент в компании используется достаточное количество данных средств. Без них управление всей этой инфраструктурой будет крайне затруднено.
```
Какие инструменты из уже используемых вы хотели бы использовать для нового проекта?
```
На начальной стадии проекта я представляю использование свзки ansible+terraform для управления инфраструктурой. Так-же можно использовать docker для подготовки образов контейнеров.
На поздней стадии использовать docker+packer+terraform для управления неизменяемой инфраструктурой и kubernetes для оркестрации.
```
Хотите ли рассмотреть возможность внедрения новых инструментов для этого проекта?
```
Возможность внедрения новых инструментов конечно будет рассматриваться. Пока-же мои знания и о текущих инструментах недостаточны, не говоря уже о предложении новых.
```

## Обязательная задача 2. Установка терраформ.

Установите терраформ при помощи менеджера пакетов используемого в вашей операционной системе. В виде результата этой задачи приложите вывод команды terraform --version.
```
student@student-virtual-machine:~$ terraform version
Terraform v1.1.7
on linux_amd64

```

## Обязательная задача 3. Поддержка легаси кода.

В какой-то момент вы обновили терраформ до новой версии, например с 0.12 до 0.13. А код одного из проектов настолько устарел, что не может работать с версией 0.13. 
В связи с этим необходимо сделать так, чтобы вы могли одновременно использовать последнюю версию терраформа установленную при помощи штатного менеджера пакетов и устаревшую версию 0.12.
В виде результата этой задачи приложите вывод --version двух версий терраформа доступных на вашем компьютере или виртуальной машине.
```
Для выполнения задания воспользовался утилитой tfnev.
Установка tfenv

student@student-virtual-machine:~$ mkdir .tfenv
student@student-virtual-machine:~$ git clone https://github.com/tfutils/tfenv.git ~/.tfenv
Cloning into '/home/student/.tfenv'...
remote: Enumerating objects: 1569, done.
remote: Counting objects: 100% (384/384), done.
remote: Compressing objects: 100% (150/150), done.
remote: Total 1569 (delta 240), reused 344 (delta 220), pack-reused 1185
Receiving objects: 100% (1569/1569), 337.72 KiB | 4.69 MiB/s, done.
Resolving deltas: 100% (1003/1003), done.
student@student-virtual-machine:~$ echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile 
student@student-virtual-machine:~$ mkdir -p ~/.local/bin/
student@student-virtual-machine:~$ . ~/.profile
student@student-virtual-machine:~$ ln -s ~/.tfenv/bin/* ~/.local/bin
student@student-virtual-machine:~$ tfenv
tfenv 2.2.3

Установка вресий terraform

student@student-virtual-machine:~$ tfenv list
No versions available. Please install one with: tfenv install
student@student-virtual-machine:~$ tfenv install latest
Installing Terraform v1.1.7
Downloading release tarball from https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_linux_amd64.zip
################################################################################################################################################################# 100,0%
Downloading SHA hash file from https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_SHA256SUMS
No keybase install found, skipping OpenPGP signature verification
Archive:  /tmp/tfenv_download.kjWdz8/terraform_1.1.7_linux_amd64.zip
  inflating: /home/student/.tfenv/versions/1.1.7/terraform  
Installation of terraform v1.1.7 successful. To make this your default version, run 'tfenv use 1.1.7'
student@student-virtual-machine:~$ tfenv list
  1.1.7
No default set. Set with 'tfenv use <version>'
student@student-virtual-machine:~$ tfenv install 0.12.31
Installing Terraform v0.12.31
Downloading release tarball from https://releases.hashicorp.com/terraform/0.12.31/terraform_0.12.31_linux_amd64.zip
################################################################################################################################################################# 100,0%
Downloading SHA hash file from https://releases.hashicorp.com/terraform/0.12.31/terraform_0.12.31_SHA256SUMS
No keybase install found, skipping OpenPGP signature verification
Archive:  /tmp/tfenv_download.FkEe9c/terraform_0.12.31_linux_amd64.zip
  inflating: /home/student/.tfenv/versions/0.12.31/terraform  
Installation of terraform v0.12.31 successful. To make this your default version, run 'tfenv use 0.12.31'
student@student-virtual-machine:~$ tfenv list
  1.1.7
  0.12.31
No default set. Set with 'tfenv use <version>'

Проверка результата

student@student-virtual-machine:~$ tfenv use 1.1.7
Switching default version to v1.1.7
Switching completed
student@student-virtual-machine:~$ terraform -v
Terraform v1.1.7
on linux_amd64
student@student-virtual-machine:~$ tfenv use 0.12.31
Switching default version to v0.12.31
Switching completed
student@student-virtual-machine:~$ terraform -v
Terraform v0.12.31

Your version of Terraform is out of date! The latest version
is 1.1.7. You can update by downloading from https://www.terraform.io/downloads.html
```
