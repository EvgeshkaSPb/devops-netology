# Домашнее задание к занятию "09.03 CI\CD"

## Подготовка к выполнению

1. Создать 2 VM: для jenkins-master и jenkins-agent.
2. Установить jenkins при помощи playbook'a.
3. Запустить и проверить работоспособность.
4. Сделать первоначальную настройку.

## Решение

Предоставленный в рамках ДЗ playbook развернул 2 ВМ jenkins-master и jenkins-agent.
jenkins-agent оказался неработоспособен ввиду сложных требований по совместимости Molecule-python-ansible.
Создал собственный агент на платфоме Ubuntu 20.04 и установил в него набор приложений:  

<details><summary></summary>

```
admin@jenkins-agent-02:~$ docker --version
Docker version 20.10.12, build 20.10.12-0ubuntu2~20.04.1
admin@jenkins-agent-02:~$ pip3 --version
pip 20.0.2 from /usr/lib/python3/dist-packages/pip (python 3.8)
admin@jenkins-agent-02:~$ python3 --version
Python 3.8.10
admin@jenkins-agent-02:~$ ansible --version
ansible [core 2.13.2]
  config file = None
  configured module search path = ['/home/admin/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/admin/.local/lib/python3.8/site-packages/ansible
  ansible collection location = /home/admin/.ansible/collections:/usr/share/ansible/collections
  executable location = /home/admin/.local/bin/ansible
  python version = 3.8.10 (default, Jun 22 2022, 20:18:18) [GCC 9.4.0]
  jinja version = 3.1.2
  libyaml = True
admin@jenkins-agent-02:~$ java --version
openjdk 11.0.15 2022-04-19
OpenJDK Runtime Environment (build 11.0.15+10-Ubuntu-0ubuntu0.20.04.1)
OpenJDK 64-Bit Server VM (build 11.0.15+10-Ubuntu-0ubuntu0.20.04.1, mixed mode, sharing)
```
</details>

Провел настройку подключения клиента через SSH.

## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
Решение:
Был создан репозиторий включающий себя playbook с ролями ссылка https://github.com/EvgenAnsible1/Jenkins
Дополнительно, для работы molecule, была сделана настройка агента (PATH+EXTRA)=(/home/jenkins/.local/bin).  
Команды shell Freestyle job
<details><summary></summary>

```
cd roles/vector
molecule --version
molecule test -s ubuntu_lastest
```

</details>

Вывод консоли Freestyle job:    
<details><summary></summary>

```
19:15:08 Started by user Evgeniy Smirnov
19:15:08 Running as SYSTEM
19:15:08 Building remotely on ubuntu-agent in workspace /home/jenkins/workspace/FreeStyle homework
19:15:08 [WS-CLEANUP] Deleting project workspace...
19:15:08 [WS-CLEANUP] Deferred wipeout is used...
19:15:08 [WS-CLEANUP] Done
19:15:08 The recommended git tool is: NONE
19:15:08 using credential 8a4a0522-9255-45d3-b962-a12a7d0c80ee
19:15:08 Cloning the remote Git repository
19:15:08 Cloning repository git@github.com:EvgenAnsible1/Jenkins.git
19:15:08  > git init /home/jenkins/workspace/FreeStyle homework # timeout=10
19:15:08 Fetching upstream changes from git@github.com:EvgenAnsible1/Jenkins.git
19:15:08  > git --version # timeout=10
19:15:08  > git --version # 'git version 2.25.1'
19:15:08 using GIT_SSH to set credentials 
19:15:08  > git fetch --tags --force --progress -- git@github.com:EvgenAnsible1/Jenkins.git +refs/heads/*:refs/remotes/origin/* # timeout=10
19:15:09  > git config remote.origin.url git@github.com:EvgenAnsible1/Jenkins.git # timeout=10
19:15:09  > git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/* # timeout=10
19:15:09 Avoid second fetch
19:15:09  > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
19:15:09 Checking out Revision b01d4d711e1b353b8051c87153b99f9f3e700a30 (refs/remotes/origin/main)
19:15:09  > git config core.sparsecheckout # timeout=10
19:15:09  > git checkout -f b01d4d711e1b353b8051c87153b99f9f3e700a30 # timeout=10
19:15:09 Commit message: "jenkins"
19:15:09 First time build. Skipping changelog.
19:15:09 [FreeStyle homework] $ /bin/sh -xe /tmp/jenkins3133602254010202261.sh
19:15:10 + cd roles/vector
19:15:10 + molecule --version
19:15:11 molecule 4.0.0 using python 3.8 
19:15:11     ansible:2.13.2
19:15:11     delegated:4.0.0 from molecule
19:15:11     docker:2.0.0 from molecule_docker requiring collections: community.docker>=3.0.0-a2
19:15:11 + molecule test -s ubuntu_lastest
19:15:11 INFO     ubuntu_lastest scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
19:15:11 INFO     Performing prerun with role_name_check=0...
19:15:11 INFO     Set ANSIBLE_LIBRARY=/home/jenkins/.cache/ansible-compat/b0d51c/modules:/home/jenkins/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
19:15:12 INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/jenkins/.cache/ansible-compat/b0d51c/collections:/home/jenkins/.ansible/collections:/usr/share/ansible/collections
19:15:12 INFO     Set ANSIBLE_ROLES_PATH=/home/jenkins/.cache/ansible-compat/b0d51c/roles:/home/jenkins/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
19:15:12 INFO     Using /home/jenkins/.cache/ansible-compat/b0d51c/roles/my_namespace.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
19:15:12 INFO     Running ubuntu_lastest > dependency
19:15:12 INFO     Running ansible-galaxy collection install -v --pre community.docker:>=3.0.0-a2
19:15:15 WARNING  Skipping, missing the requirements file.
19:15:15 WARNING  Skipping, missing the requirements file.
19:15:15 INFO     Running ubuntu_lastest > lint
19:15:15 INFO     Lint is disabled.
19:15:15 INFO     Running ubuntu_lastest > cleanup
19:15:15 WARNING  Skipping, cleanup playbook not configured.
19:15:15 INFO     Running ubuntu_lastest > destroy
19:15:15 INFO     Sanity checks: 'docker'
19:15:16 
19:15:16 PLAY [Destroy] *****************************************************************
19:15:16 
19:15:16 TASK [Destroy molecule instance(s)] ********************************************
19:15:16 changed: [localhost] => (item=instance)
19:15:16 
19:15:16 TASK [Wait for instance(s) deletion to complete] *******************************
19:15:17 ok: [localhost] => (item=instance)
19:15:17 
19:15:17 TASK [Delete docker networks(s)] ***********************************************
19:15:17 
19:15:17 PLAY RECAP *********************************************************************
19:15:17 localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
19:15:17 
19:15:17 INFO     Running ubuntu_lastest > syntax
19:15:17 
19:15:17 playbook: /home/jenkins/workspace/FreeStyle homework/roles/vector/molecule/ubuntu_lastest/converge.yml
19:15:17 INFO     Running ubuntu_lastest > create
19:15:18 
19:15:18 PLAY [Create] ******************************************************************
19:15:18 
19:15:18 TASK [Log into a Docker registry] **********************************************
19:15:18 skipping: [localhost] => (item=None)
19:15:18 skipping: [localhost]
19:15:18 
19:15:18 TASK [Check presence of custom Dockerfiles] ************************************
19:15:18 ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})
19:15:18 
19:15:18 TASK [Create Dockerfiles from image names] *************************************
19:15:18 skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})
19:15:18 
19:15:18 TASK [Discover local Docker images] ********************************************
19:15:19 ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
19:15:19 
19:15:19 TASK [Build an Ansible compatible image (new)] *********************************
19:15:19 skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest)
19:15:19 
19:15:19 TASK [Create docker network(s)] ************************************************
19:15:19 
19:15:19 TASK [Determine the CMD directives] ********************************************
19:15:19 ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})
19:15:19 
19:15:19 TASK [Create molecule instance(s)] *********************************************
19:15:20 changed: [localhost] => (item=instance)
19:15:20 
19:15:20 TASK [Wait for instance(s) creation to complete] *******************************
19:15:20 FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
19:15:25 changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '444628906667.7628', 'results_file': '/home/jenkins/.ansible_async/444628906667.7628', 'changed': True, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
19:15:25 
19:15:25 PLAY RECAP *********************************************************************
19:15:25 localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
19:15:25 
19:15:25 INFO     Running ubuntu_lastest > prepare
19:15:25 WARNING  Skipping, prepare playbook not configured.
19:15:25 INFO     Running ubuntu_lastest > converge
19:15:26 
19:15:26 PLAY [Converge] ****************************************************************
19:15:26 
19:15:26 TASK [Gathering Facts] *********************************************************
19:15:28 ok: [instance]
19:15:28 
19:15:28 TASK [Include vector] **********************************************************
19:15:28 
19:15:28 TASK [vector : Vector | install Vector distrib | CentOS] ***********************
19:15:28 skipping: [instance]
19:15:28 
19:15:28 TASK [vector : Vector | install Vector distrib | Ubuntu] ***********************
19:15:40 changed: [instance]
19:15:40 
19:15:40 TASK [vector : Vector | Create directory for Vector logs] **********************
19:15:41 changed: [instance]
19:15:41 
19:15:41 TASK [vector : Vector | Template config] ***************************************
19:15:43 changed: [instance]
19:15:43 
19:15:43 TASK [vector : Vector | create systemd unit] ***********************************
19:15:44 changed: [instance]
19:15:44 
19:15:44 TASK [vector : Vector | Start service] *****************************************
19:15:44 skipping: [instance]
19:15:44 
19:15:44 PLAY RECAP *********************************************************************
19:15:44 instance                   : ok=5    changed=4    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
19:15:44 
19:15:44 INFO     Running ubuntu_lastest > idempotence
19:15:45 
19:15:45 PLAY [Converge] ****************************************************************
19:15:45 
19:15:45 TASK [Gathering Facts] *********************************************************
19:15:46 ok: [instance]
19:15:46 
19:15:46 TASK [Include vector] **********************************************************
19:15:46 
19:15:46 TASK [vector : Vector | install Vector distrib | CentOS] ***********************
19:15:46 skipping: [instance]
19:15:46 
19:15:46 TASK [vector : Vector | install Vector distrib | Ubuntu] ***********************
19:15:53 ok: [instance]
19:15:53 
19:15:53 TASK [vector : Vector | Create directory for Vector logs] **********************
19:15:54 ok: [instance]
19:15:54 
19:15:54 TASK [vector : Vector | Template config] ***************************************
19:15:55 ok: [instance]
19:15:55 
19:15:55 TASK [vector : Vector | create systemd unit] ***********************************
19:15:57 ok: [instance]
19:15:57 
19:15:57 TASK [vector : Vector | Start service] *****************************************
19:15:57 skipping: [instance]
19:15:57 
19:15:57 PLAY RECAP *********************************************************************
19:15:57 instance                   : ok=5    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
19:15:57 
19:15:57 INFO     Idempotence completed successfully.
19:15:57 INFO     Running ubuntu_lastest > side_effect
19:15:57 WARNING  Skipping, side effect playbook not configured.
19:15:57 INFO     Running ubuntu_lastest > verify
19:15:57 INFO     Running Ansible Verifier
19:15:57 
19:15:57 PLAY [Verify] ******************************************************************
19:15:57 
19:15:57 TASK [Get Vector version] ******************************************************
19:15:58 ok: [instance]
19:15:58 
19:15:58 TASK [Assert Vector instalation] ***********************************************
19:15:59 ok: [instance] => {
19:15:59     "changed": false,
19:15:59     "msg": "All assertions passed"
19:15:59 }
19:15:59 
19:15:59 TASK [Validate vector config file] *********************************************
19:15:59 ok: [instance]
19:15:59 
19:15:59 TASK [Assert Vector validate config] *******************************************
19:15:59 ok: [instance] => {
19:15:59     "changed": false,
19:15:59     "msg": "All assertions passed"
19:15:59 }
19:15:59 
19:15:59 PLAY RECAP *********************************************************************
19:15:59 instance                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
19:15:59 
19:15:59 INFO     Verifier completed successfully.
19:15:59 INFO     Running ubuntu_lastest > cleanup
19:15:59 WARNING  Skipping, cleanup playbook not configured.
19:15:59 INFO     Running ubuntu_lastest > destroy
19:16:00 
19:16:00 PLAY [Destroy] *****************************************************************
19:16:00 
19:16:00 TASK [Destroy molecule instance(s)] ********************************************
19:16:01 changed: [localhost] => (item=instance)
19:16:01 
19:16:01 TASK [Wait for instance(s) deletion to complete] *******************************
19:16:01 FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
19:16:06 changed: [localhost] => (item=instance)
19:16:06 
19:16:06 TASK [Delete docker networks(s)] ***********************************************
19:16:06 
19:16:06 PLAY RECAP *********************************************************************
19:16:06 localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
19:16:06 
19:16:06 INFO     Pruning extra files from scenario ephemeral directory
19:16:06 Finished: SUCCESS
```
</details>

2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.  
Вывод консоли:
<details><summary></summary>

```
Started by user Evgeniy Smirnov
[Pipeline] Start of Pipeline
[Pipeline] node
Running on ubuntu-agent in /home/jenkins/workspace/Declarative
[Pipeline] {
[Pipeline] stage
[Pipeline] { (checkout dir)
[Pipeline] git
The recommended git tool is: NONE
using credential 8a4a0522-9255-45d3-b962-a12a7d0c80ee
Fetching changes from the remote Git repository
 > git rev-parse --resolve-git-dir /home/jenkins/workspace/Declarative/.git # timeout=10
 > git config remote.origin.url git@github.com:EvgenAnsible1/Jenkins.git # timeout=10
Fetching upstream changes from git@github.com:EvgenAnsible1/Jenkins.git
 > git --version # timeout=10
 > git --version # 'git version 2.25.1'
using GIT_SSH to set credentials 
 > git fetch --tags --force --progress -- git@github.com:EvgenAnsible1/Jenkins.git +refs/heads/*:refs/remotes/origin/* # timeout=10
Checking out Revision b01d4d711e1b353b8051c87153b99f9f3e700a30 (refs/remotes/origin/main)
Commit message: "jenkins"
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f b01d4d711e1b353b8051c87153b99f9f3e700a30 # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git branch -D main # timeout=10
 > git checkout -b main b01d4d711e1b353b8051c87153b99f9f3e700a30 # timeout=10
 > git rev-list --no-walk b01d4d711e1b353b8051c87153b99f9f3e700a30 # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (install molecule)
[Pipeline] sh
+ pip3 install molecule==4.0.0
Requirement already satisfied: molecule==4.0.0 in /home/jenkins/.local/lib/python3.8/site-packages (4.0.0)
Requirement already satisfied: cookiecutter>=1.7.3 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (2.1.1)
Requirement already satisfied: enrich>=1.2.7 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (1.2.7)
Requirement already satisfied: ansible-compat>=2.1.0 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (2.2.0)
Requirement already satisfied: packaging in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (21.3)
Requirement already satisfied: Jinja2>=2.11.3 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (3.1.2)
Requirement already satisfied: pluggy<2.0,>=0.7.1 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (1.0.0)
Requirement already satisfied: PyYAML>=5.1 in /usr/lib/python3/dist-packages (from molecule==4.0.0) (5.3.1)
Requirement already satisfied: cerberus!=1.3.3,!=1.3.4,>=1.3.1 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (1.3.2)
Requirement already satisfied: rich>=9.5.1 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (12.5.1)
Requirement already satisfied: click-help-colors>=0.9 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (0.9.1)
Requirement already satisfied: click<9,>=8.0 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (8.1.3)
Requirement already satisfied: jinja2-time>=0.2.0 in /home/jenkins/.local/lib/python3.8/site-packages (from cookiecutter>=1.7.3->molecule==4.0.0) (0.2.0)
Requirement already satisfied: python-slugify>=4.0.0 in /home/jenkins/.local/lib/python3.8/site-packages (from cookiecutter>=1.7.3->molecule==4.0.0) (6.1.2)
Requirement already satisfied: requests>=2.23.0 in /home/jenkins/.local/lib/python3.8/site-packages (from cookiecutter>=1.7.3->molecule==4.0.0) (2.28.1)
Requirement already satisfied: binaryornot>=0.4.4 in /home/jenkins/.local/lib/python3.8/site-packages (from cookiecutter>=1.7.3->molecule==4.0.0) (0.4.4)
Requirement already satisfied: subprocess-tee>=0.3.5 in /home/jenkins/.local/lib/python3.8/site-packages (from ansible-compat>=2.1.0->molecule==4.0.0) (0.3.5)
Requirement already satisfied: jsonschema>=4.6.0 in /home/jenkins/.local/lib/python3.8/site-packages (from ansible-compat>=2.1.0->molecule==4.0.0) (4.7.2)
Requirement already satisfied: pyparsing!=3.0.5,>=2.0.2 in /home/jenkins/.local/lib/python3.8/site-packages (from packaging->molecule==4.0.0) (3.0.9)
Requirement already satisfied: MarkupSafe>=2.0 in /home/jenkins/.local/lib/python3.8/site-packages (from Jinja2>=2.11.3->molecule==4.0.0) (2.1.1)
Requirement already satisfied: setuptools in /usr/lib/python3/dist-packages (from cerberus!=1.3.3,!=1.3.4,>=1.3.1->molecule==4.0.0) (45.2.0)
Requirement already satisfied: pygments<3.0.0,>=2.6.0 in /home/jenkins/.local/lib/python3.8/site-packages (from rich>=9.5.1->molecule==4.0.0) (2.12.0)
Requirement already satisfied: typing-extensions<5.0,>=4.0.0; python_version < "3.9" in /home/jenkins/.local/lib/python3.8/site-packages (from rich>=9.5.1->molecule==4.0.0) (4.3.0)
Requirement already satisfied: commonmark<0.10.0,>=0.9.0 in /home/jenkins/.local/lib/python3.8/site-packages (from rich>=9.5.1->molecule==4.0.0) (0.9.1)
Requirement already satisfied: arrow in /home/jenkins/.local/lib/python3.8/site-packages (from jinja2-time>=0.2.0->cookiecutter>=1.7.3->molecule==4.0.0) (1.2.2)
Requirement already satisfied: text-unidecode>=1.3 in /home/jenkins/.local/lib/python3.8/site-packages (from python-slugify>=4.0.0->cookiecutter>=1.7.3->molecule==4.0.0) (1.3)
Requirement already satisfied: idna<4,>=2.5 in /usr/lib/python3/dist-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==4.0.0) (2.8)
Requirement already satisfied: urllib3<1.27,>=1.21.1 in /usr/lib/python3/dist-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==4.0.0) (1.25.8)
Requirement already satisfied: charset-normalizer<3,>=2 in /home/jenkins/.local/lib/python3.8/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==4.0.0) (2.1.0)
Requirement already satisfied: certifi>=2017.4.17 in /usr/lib/python3/dist-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==4.0.0) (2019.11.28)
Requirement already satisfied: chardet>=3.0.2 in /usr/lib/python3/dist-packages (from binaryornot>=0.4.4->cookiecutter>=1.7.3->molecule==4.0.0) (3.0.4)
Requirement already satisfied: pyrsistent!=0.17.0,!=0.17.1,!=0.17.2,>=0.14.0 in /usr/lib/python3/dist-packages (from jsonschema>=4.6.0->ansible-compat>=2.1.0->molecule==4.0.0) (0.15.5)
Requirement already satisfied: importlib-resources>=1.4.0; python_version < "3.9" in /home/jenkins/.local/lib/python3.8/site-packages (from jsonschema>=4.6.0->ansible-compat>=2.1.0->molecule==4.0.0) (5.9.0)
Requirement already satisfied: attrs>=17.4.0 in /usr/lib/python3/dist-packages (from jsonschema>=4.6.0->ansible-compat>=2.1.0->molecule==4.0.0) (19.3.0)
Requirement already satisfied: python-dateutil>=2.7.0 in /home/jenkins/.local/lib/python3.8/site-packages (from arrow->jinja2-time>=0.2.0->cookiecutter>=1.7.3->molecule==4.0.0) (2.8.2)
Requirement already satisfied: zipp>=3.1.0; python_version < "3.10" in /home/jenkins/.local/lib/python3.8/site-packages (from importlib-resources>=1.4.0; python_version < "3.9"->jsonschema>=4.6.0->ansible-compat>=2.1.0->molecule==4.0.0) (3.8.1)
Requirement already satisfied: six>=1.5 in /usr/lib/python3/dist-packages (from python-dateutil>=2.7.0->arrow->jinja2-time>=0.2.0->cookiecutter>=1.7.3->molecule==4.0.0) (1.14.0)
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (run molecule)
[Pipeline] dir
Running in /home/jenkins/workspace/Declarative/roles/vector
[Pipeline] {
[Pipeline] sh
+ molecule test -s ubuntu_lastest
INFO     ubuntu_lastest scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/jenkins/.cache/ansible-compat/b0d51c/modules:/home/jenkins/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/jenkins/.cache/ansible-compat/b0d51c/collections:/home/jenkins/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/jenkins/.cache/ansible-compat/b0d51c/roles:/home/jenkins/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /home/jenkins/.cache/ansible-compat/b0d51c/roles/my_namespace.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running ubuntu_lastest > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running ubuntu_lastest > lint
INFO     Lint is disabled.
INFO     Running ubuntu_lastest > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running ubuntu_lastest > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
ok: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running ubuntu_lastest > syntax

playbook: /home/jenkins/workspace/Declarative/roles/vector/molecule/ubuntu_lastest/converge.yml
INFO     Running ubuntu_lastest > create

PLAY [Create] ******************************************************************

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None)
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest)

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '477925062713.18465', 'results_file': '/home/jenkins/.ansible_async/477925062713.18465', 'changed': True, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running ubuntu_lastest > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running ubuntu_lastest > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include vector] **********************************************************

TASK [vector : Vector | install Vector distrib | CentOS] ***********************
skipping: [instance]

TASK [vector : Vector | install Vector distrib | Ubuntu] ***********************
changed: [instance]

TASK [vector : Vector | Create directory for Vector logs] **********************
changed: [instance]

TASK [vector : Vector | Template config] ***************************************
changed: [instance]

TASK [vector : Vector | create systemd unit] ***********************************
changed: [instance]

TASK [vector : Vector | Start service] *****************************************
skipping: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=5    changed=4    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Running ubuntu_lastest > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include vector] **********************************************************

TASK [vector : Vector | install Vector distrib | CentOS] ***********************
skipping: [instance]

TASK [vector : Vector | install Vector distrib | Ubuntu] ***********************
ok: [instance]

TASK [vector : Vector | Create directory for Vector logs] **********************
ok: [instance]

TASK [vector : Vector | Template config] ***************************************
ok: [instance]

TASK [vector : Vector | create systemd unit] ***********************************
ok: [instance]

TASK [vector : Vector | Start service] *****************************************
skipping: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=5    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running ubuntu_lastest > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running ubuntu_lastest > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Get Vector version] ******************************************************
ok: [instance]

TASK [Assert Vector instalation] ***********************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Validate vector config file] *********************************************
ok: [instance]

TASK [Assert Vector validate config] *******************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
instance                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running ubuntu_lastest > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running ubuntu_lastest > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
[Pipeline] }
[Pipeline] // dir
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```

</details>

3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.
4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.  
Вывод консоли:
<details><summary></summary>

```
Branch indexing
 > git rev-parse --resolve-git-dir /var/lib/jenkins/caches/git-73a8dd7baa409a0b6016fd3717d7eae3/.git # timeout=10
Setting origin to git@github.com:EvgenAnsible1/Jenkins.git
 > git config remote.origin.url git@github.com:EvgenAnsible1/Jenkins.git # timeout=10
Fetching origin...
Fetching upstream changes from origin
 > git --version # timeout=10
 > git --version # 'git version 1.8.3.1'
 > git config --get remote.origin.url # timeout=10
using GIT_SSH to set credentials 
[INFO] Currently running in a labeled security context
[INFO] Currently SELinux is 'enforcing' on the host
 > /usr/bin/chcon --type=ssh_home_t /var/lib/jenkins/caches/git-73a8dd7baa409a0b6016fd3717d7eae3@tmp/jenkins-gitclient-ssh13744680650206821820.key
 > git fetch --tags --progress origin +refs/heads/*:refs/remotes/origin/* # timeout=10
Seen branch in repository origin/main
Seen 1 remote branch
Obtained Jenkinsfile from 536b6c53d965a1fb9e23ff319f0d3abc2cc57a99
[Pipeline] Start of Pipeline
[Pipeline] node
Running on ubuntu-agent in /home/jenkins/workspace/Multibranch_main
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Declarative: Checkout SCM)
[Pipeline] checkout
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
using credential 8a4a0522-9255-45d3-b962-a12a7d0c80ee
Cloning the remote Git repository
Cloning with configured refspecs honoured and without tags
Cloning repository git@github.com:EvgenAnsible1/Jenkins.git
 > git init /home/jenkins/workspace/Multibranch_main # timeout=10
Fetching upstream changes from git@github.com:EvgenAnsible1/Jenkins.git
 > git --version # timeout=10
 > git --version # 'git version 2.25.1'
using GIT_SSH to set credentials 
 > git fetch --no-tags --force --progress -- git@github.com:EvgenAnsible1/Jenkins.git +refs/heads/*:refs/remotes/origin/* # timeout=10
Avoid second fetch
Checking out Revision 536b6c53d965a1fb9e23ff319f0d3abc2cc57a99 (main)
Commit message: "add Jenkinsfile"
First time build. Skipping changelog.
[Pipeline] }
[Pipeline] // stage
[Pipeline] withEnv
[Pipeline] {
[Pipeline] stage
[Pipeline] { (checkout dir)
[Pipeline] git
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
using credential 8a4a0522-9255-45d3-b962-a12a7d0c80ee
Fetching changes from the remote Git repository
 > git config remote.origin.url git@github.com:EvgenAnsible1/Jenkins.git # timeout=10
 > git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 536b6c53d965a1fb9e23ff319f0d3abc2cc57a99 # timeout=10
 > git rev-parse --resolve-git-dir /home/jenkins/workspace/Multibranch_main/.git # timeout=10
 > git config remote.origin.url git@github.com:EvgenAnsible1/Jenkins.git # timeout=10
Fetching upstream changes from git@github.com:EvgenAnsible1/Jenkins.git
 > git --version # timeout=10
 > git --version # 'git version 2.25.1'
using GIT_SSH to set credentials 
 > git fetch --tags --force --progress -- git@github.com:EvgenAnsible1/Jenkins.git +refs/heads/*:refs/remotes/origin/* # timeout=10
Checking out Revision 536b6c53d965a1fb9e23ff319f0d3abc2cc57a99 (refs/remotes/origin/main)
Commit message: "add Jenkinsfile"
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (install molecule)
[Pipeline] sh
+ pip3 install molecule==4.0.0
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 536b6c53d965a1fb9e23ff319f0d3abc2cc57a99 # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git checkout -b main 536b6c53d965a1fb9e23ff319f0d3abc2cc57a99 # timeout=10
Requirement already satisfied: molecule==4.0.0 in /home/jenkins/.local/lib/python3.8/site-packages (4.0.0)
Requirement already satisfied: cookiecutter>=1.7.3 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (2.1.1)
Requirement already satisfied: enrich>=1.2.7 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (1.2.7)
Requirement already satisfied: ansible-compat>=2.1.0 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (2.2.0)
Requirement already satisfied: click-help-colors>=0.9 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (0.9.1)
Requirement already satisfied: cerberus!=1.3.3,!=1.3.4,>=1.3.1 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (1.3.2)
Requirement already satisfied: pluggy<2.0,>=0.7.1 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (1.0.0)
Requirement already satisfied: Jinja2>=2.11.3 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (3.1.2)
Requirement already satisfied: packaging in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (21.3)
Requirement already satisfied: PyYAML>=5.1 in /usr/lib/python3/dist-packages (from molecule==4.0.0) (5.3.1)
Requirement already satisfied: rich>=9.5.1 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (12.5.1)
Requirement already satisfied: click<9,>=8.0 in /home/jenkins/.local/lib/python3.8/site-packages (from molecule==4.0.0) (8.1.3)
Requirement already satisfied: python-slugify>=4.0.0 in /home/jenkins/.local/lib/python3.8/site-packages (from cookiecutter>=1.7.3->molecule==4.0.0) (6.1.2)
Requirement already satisfied: requests>=2.23.0 in /home/jenkins/.local/lib/python3.8/site-packages (from cookiecutter>=1.7.3->molecule==4.0.0) (2.28.1)
Requirement already satisfied: binaryornot>=0.4.4 in /home/jenkins/.local/lib/python3.8/site-packages (from cookiecutter>=1.7.3->molecule==4.0.0) (0.4.4)
Requirement already satisfied: jinja2-time>=0.2.0 in /home/jenkins/.local/lib/python3.8/site-packages (from cookiecutter>=1.7.3->molecule==4.0.0) (0.2.0)
Requirement already satisfied: jsonschema>=4.6.0 in /home/jenkins/.local/lib/python3.8/site-packages (from ansible-compat>=2.1.0->molecule==4.0.0) (4.7.2)
Requirement already satisfied: subprocess-tee>=0.3.5 in /home/jenkins/.local/lib/python3.8/site-packages (from ansible-compat>=2.1.0->molecule==4.0.0) (0.3.5)
Requirement already satisfied: setuptools in /usr/lib/python3/dist-packages (from cerberus!=1.3.3,!=1.3.4,>=1.3.1->molecule==4.0.0) (45.2.0)
Requirement already satisfied: MarkupSafe>=2.0 in /home/jenkins/.local/lib/python3.8/site-packages (from Jinja2>=2.11.3->molecule==4.0.0) (2.1.1)
Requirement already satisfied: pyparsing!=3.0.5,>=2.0.2 in /home/jenkins/.local/lib/python3.8/site-packages (from packaging->molecule==4.0.0) (3.0.9)
Requirement already satisfied: commonmark<0.10.0,>=0.9.0 in /home/jenkins/.local/lib/python3.8/site-packages (from rich>=9.5.1->molecule==4.0.0) (0.9.1)
Requirement already satisfied: pygments<3.0.0,>=2.6.0 in /home/jenkins/.local/lib/python3.8/site-packages (from rich>=9.5.1->molecule==4.0.0) (2.12.0)
Requirement already satisfied: typing-extensions<5.0,>=4.0.0; python_version < "3.9" in /home/jenkins/.local/lib/python3.8/site-packages (from rich>=9.5.1->molecule==4.0.0) (4.3.0)
Requirement already satisfied: text-unidecode>=1.3 in /home/jenkins/.local/lib/python3.8/site-packages (from python-slugify>=4.0.0->cookiecutter>=1.7.3->molecule==4.0.0) (1.3)
Requirement already satisfied: urllib3<1.27,>=1.21.1 in /usr/lib/python3/dist-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==4.0.0) (1.25.8)
Requirement already satisfied: charset-normalizer<3,>=2 in /home/jenkins/.local/lib/python3.8/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==4.0.0) (2.1.0)
Requirement already satisfied: certifi>=2017.4.17 in /usr/lib/python3/dist-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==4.0.0) (2019.11.28)
Requirement already satisfied: idna<4,>=2.5 in /usr/lib/python3/dist-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==4.0.0) (2.8)
Requirement already satisfied: chardet>=3.0.2 in /usr/lib/python3/dist-packages (from binaryornot>=0.4.4->cookiecutter>=1.7.3->molecule==4.0.0) (3.0.4)
Requirement already satisfied: arrow in /home/jenkins/.local/lib/python3.8/site-packages (from jinja2-time>=0.2.0->cookiecutter>=1.7.3->molecule==4.0.0) (1.2.2)
Requirement already satisfied: importlib-resources>=1.4.0; python_version < "3.9" in /home/jenkins/.local/lib/python3.8/site-packages (from jsonschema>=4.6.0->ansible-compat>=2.1.0->molecule==4.0.0) (5.9.0)
Requirement already satisfied: pyrsistent!=0.17.0,!=0.17.1,!=0.17.2,>=0.14.0 in /usr/lib/python3/dist-packages (from jsonschema>=4.6.0->ansible-compat>=2.1.0->molecule==4.0.0) (0.15.5)
Requirement already satisfied: attrs>=17.4.0 in /usr/lib/python3/dist-packages (from jsonschema>=4.6.0->ansible-compat>=2.1.0->molecule==4.0.0) (19.3.0)
Requirement already satisfied: python-dateutil>=2.7.0 in /home/jenkins/.local/lib/python3.8/site-packages (from arrow->jinja2-time>=0.2.0->cookiecutter>=1.7.3->molecule==4.0.0) (2.8.2)
Requirement already satisfied: zipp>=3.1.0; python_version < "3.10" in /home/jenkins/.local/lib/python3.8/site-packages (from importlib-resources>=1.4.0; python_version < "3.9"->jsonschema>=4.6.0->ansible-compat>=2.1.0->molecule==4.0.0) (3.8.1)
Requirement already satisfied: six>=1.5 in /usr/lib/python3/dist-packages (from python-dateutil>=2.7.0->arrow->jinja2-time>=0.2.0->cookiecutter>=1.7.3->molecule==4.0.0) (1.14.0)
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (run molecule)
[Pipeline] dir
Running in /home/jenkins/workspace/Multibranch_main/roles/vector
[Pipeline] {
[Pipeline] sh
+ molecule test -s ubuntu_lastest
INFO     ubuntu_lastest scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/jenkins/.cache/ansible-compat/b0d51c/modules:/home/jenkins/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/jenkins/.cache/ansible-compat/b0d51c/collections:/home/jenkins/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/jenkins/.cache/ansible-compat/b0d51c/roles:/home/jenkins/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /home/jenkins/.cache/ansible-compat/b0d51c/roles/my_namespace.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running ubuntu_lastest > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running ubuntu_lastest > lint
INFO     Lint is disabled.
INFO     Running ubuntu_lastest > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running ubuntu_lastest > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
ok: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running ubuntu_lastest > syntax

playbook: /home/jenkins/workspace/Multibranch_main/roles/vector/molecule/ubuntu_lastest/converge.yml
INFO     Running ubuntu_lastest > create

PLAY [Create] ******************************************************************

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None)
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest)

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '378152440673.21858', 'results_file': '/home/jenkins/.ansible_async/378152440673.21858', 'changed': True, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running ubuntu_lastest > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running ubuntu_lastest > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include vector] **********************************************************

TASK [vector : Vector | install Vector distrib | CentOS] ***********************
skipping: [instance]

TASK [vector : Vector | install Vector distrib | Ubuntu] ***********************
changed: [instance]

TASK [vector : Vector | Create directory for Vector logs] **********************
changed: [instance]

TASK [vector : Vector | Template config] ***************************************
changed: [instance]

TASK [vector : Vector | create systemd unit] ***********************************
changed: [instance]

TASK [vector : Vector | Start service] *****************************************
skipping: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=5    changed=4    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Running ubuntu_lastest > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include vector] **********************************************************

TASK [vector : Vector | install Vector distrib | CentOS] ***********************
skipping: [instance]

TASK [vector : Vector | install Vector distrib | Ubuntu] ***********************
ok: [instance]

TASK [vector : Vector | Create directory for Vector logs] **********************
ok: [instance]

TASK [vector : Vector | Template config] ***************************************
ok: [instance]

TASK [vector : Vector | create systemd unit] ***********************************
ok: [instance]

TASK [vector : Vector | Start service] *****************************************
skipping: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=5    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running ubuntu_lastest > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running ubuntu_lastest > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Get Vector version] ******************************************************
ok: [instance]

TASK [Assert Vector instalation] ***********************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Validate vector config file] *********************************************
ok: [instance]

TASK [Assert Vector validate config] *******************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
instance                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running ubuntu_lastest > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running ubuntu_lastest > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
[Pipeline] }
[Pipeline] // dir
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```

</details>

5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).
6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True), по умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.
8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.

Решение:  
[Репозиторий](https://github.com/EvgenAnsible1/Jenkins)  
[Declarative Pipeline](https://github.com/EvgenAnsible1/Jenkins/blob/main/Jenkinsfile)  
[Scripted Pipeline](https://github.com/EvgenAnsible1/Jenkins/blob/main/ScriptedJenkinsfile)
