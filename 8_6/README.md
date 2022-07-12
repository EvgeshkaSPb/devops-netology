# Домашнее задание к занятию "08.06 Создание собственных modules"

<font size = 5> Подготовка к выполнению </font>

Создайте пустой публичных репозиторий в любом своём проекте: my_own_collection  
Скачайте репозиторий ansible: git clone https://github.com/ansible/ansible.git по любому удобному вам пути  
Зайдите в директорию ansible: cd ansible    
Создайте виртуальное окружение: python3 -m venv venv    
Активируйте виртуальное окружение: . venv/bin/activate. Дальнейшие действия производятся только в виртуальном окружении 
Установите зависимости pip install -r requirements.txt  
Запустить настройку окружения . hacking/env-setup   
Если все шаги прошли успешно - выйти из виртуального окружения deactivate   
Ваше окружение настроено, для того чтобы запустить его, нужно находиться в директории ansible и выполнить конструкцию . venv/bin/activate && . hacking/env-setup    

<font size = 5> Основная часть </font>

Наша цель - написать собственный module, который мы можем использовать в своей role, через playbook. Всё это должно быть собрано в виде collection и отправлено в наш репозиторий.

1. В виртуальном окружении создать новый my_own_module.py файл
2. Наполнить его содержимым:

Содержимое
<details><summary></summary>

```
#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: my_test

short_description: This is my test module

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: This is my longer description explaining my test module.

options:
    name:
        description: This is the message to send to the test module.
        required: true
        type: str
    new:
        description:
            - Control to demo if the result of this module is changed or not.
            - Parameter description can be a list as well.
        required: false
        type: bool
# Specify this value according to your collection
# in format of namespace.collection.doc_fragment_name
extends_documentation_fragment:
    - my_namespace.my_collection.my_doc_fragment_name

author:
    - Your Name (@yourGitHubHandle)
'''

EXAMPLES = r'''
# Pass in a message
- name: Test with a message
  my_namespace.my_collection.my_test:
    name: hello world

# pass in a message and have changed true
- name: Test with a message and changed output
  my_namespace.my_collection.my_test:
    name: hello world
    new: true

# fail the module
- name: Test failure of the module
  my_namespace.my_collection.my_test:
    name: fail me
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
original_message:
    description: The original name param that was passed in.
    type: str
    returned: always
    sample: 'hello world'
message:
    description: The output message that the test module generates.
    type: str
    returned: always
    sample: 'goodbye'
'''

from ansible.module_utils.basic import AnsibleModule


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        name=dict(type='str', required=True),
        new=dict(type='bool', required=False, default=False)
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=False,
        original_message='',
        message=''
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    # manipulate or modify the state as needed (this is going to be the
    # part where your module will do what it needs to do)
    result['original_message'] = module.params['name']
    result['message'] = 'goodbye'

    # use whatever logic you need to determine whether or not this module
    # made any modifications to your target
    if module.params['new']:
        result['changed'] = True

    # during the execution of the module, if there is an exception or a
    # conditional state that effectively causes a failure, run
    # AnsibleModule.fail_json() to pass in the message and the result
    if module.params['name'] == 'fail me':
        module.fail_json(msg='You requested this to fail', **result)

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
```
</details>

Или возьмите данное наполнение из статьи.

3. Заполните файл в соответствии с требованиями ansible так, чтобы он выполнял основную задачу: module должен создавать текстовый файл на удалённом хосте по пути, определённом в параметре path, с содержимым, определённым в параметре content.

[my_own_module](https://github.com/EvgeshkaSPb/my_own_collection/blob/main/my_own_namespace/yandex_cloud_elk/plugins/modules/my_own_module.py)

4. Проверьте module на исполняемость локально.

Локальная проверка

<details><summary></summary>

```
(venv) student@student-virtual-machine:~/ansible-hw/8_6/ansible$ python -m ansible.modules.my_own_module input.json

{"changed": true, "original_message": "File created", "message": "File created", "invocation": {"module_args": {"path": "/tmp/test.txt", "content": "homework"}}}
```
</details>

Содержание input.json

<details><summary></summary>

```
(venv) student@student-virtual-machine:~/ansible-hw/8_6/ansible$ cat input.json 
{
    "ANSIBLE_MODULE_ARGS": {
        "path": "/tmp/test.txt",
        "content": "homework"
    }
```
</details>

5. Напишите single task playbook и используйте module в нём.

Playbook

<details><summary></summary>

```
(venv) student@student-virtual-machine:~/ansible-hw/8_6/ansible$ cat test_single_task.yml 
---
- name: Check module
  hosts: localhost
  tasks:
    - name: Test
      my_own_module:
        path: "/tmp/test.txt"
        content: "homework"
```
</details>

Вывод запуска
<details><summary></summary>

```
(venv) student@student-virtual-machine:~/ansible-hw/8_6/ansible$ ansible-playbook test_single_task.yml 
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a
rapidly changing source of code and can become unstable at any point.
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Check module] *********************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************
ok: [localhost]

TASK [Test] *****************************************************************************************************************************************************************************************
changed: [localhost]

PLAY RECAP ******************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
</details>

6. Проверьте через playbook на идемпотентность.

Вывод проверки
<details><summary></summary>

```
(venv) student@student-virtual-machine:~/ansible-hw/8_6/ansible$ ansible-playbook test_single_task.yml 
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a
rapidly changing source of code and can become unstable at any point.
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Check module] *********************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************
ok: [localhost]

TASK [Test] *****************************************************************************************************************************************************************************************
ok: [localhost]

PLAY RECAP ******************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
</details>

7. Выйдите из виртуального окружения.
8. Инициализируйте новую collection: ansible-galaxy collection init my_own_namespace.yandex_cloud_elk
9. В данную collection перенесите свой module в соответствующую директорию.
10. Single task playbook преобразуйте в single task role и перенесите в collection. У role должны быть default всех параметров module
11. Создайте playbook для использования этой role.
12. Заполните всю документацию по collection, выложите в свой репозиторий, поставьте тег 1.0.0 на этот коммит.

[repo](https://github.com/EvgeshkaSPb/my_own_collection)

13. Создайте .tar.gz этой collection: ansible-galaxy collection build в корневой директории collection.
14. Создайте ещё одну директорию любого наименования, перенесите туда single task playbook и архив c collection.
15. Установите collection из локального архива: ansible-galaxy collection install <archivename>.tar.gz
16. Запустите playbook, убедитесь, что он работает.

Вывод команд
<details><summary></summary>

```
student@student-virtual-machine:~/ansible-hw/8_6/my_own_namespace/yandex_cloud_elk$ ansible-galaxy collection build
Created collection for my_own_namespace.yandex_cloud_elk at /home/student/ansible-hw/8_6/my_own_namespace/yandex_cloud_elk/my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz
student@student-virtual-machine:~/ansible-hw/8_6/my_own_namespace/yandex_cloud_elk$ cd ../..
student@student-virtual-machine:~/ansible-hw/8_6$ mkdir play
student@student-virtual-machine:~/ansible-hw/8_6$ cd play
student@student-virtual-machine:~/ansible-hw/8_6/play$ ansible-galaxy collection install my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz --force
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Installing 'my_own_namespace.yandex_cloud_elk:1.0.0' to '/home/student/.ansible/collections/ansible_collections/my_own_namespace/yandex_cloud_elk'
my_own_namespace.yandex_cloud_elk:1.0.0 was installed successfully
student@student-virtual-machine:~/ansible-hw/8_6/play$ ansible-playbook site2.yml 
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Testing collection playbook] ******************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************
ok: [localhost]

TASK [my_own_namespace.yandex_cloud_elk.my_own_role : create file] **********************************************************************************************************************************
changed: [localhost]

PLAY RECAP ******************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

student@student-virtual-machine:~/ansible-hw/8_6/play$ cat /tmp/test.txt 
Test playbook
```
</details>

Содержание site2.yml
<details><summary></summary>

```
---
  - name: Testing collection playbook
    hosts: localhost
    collections:
      - my_own_namespace.yandex_cloud_elk
    roles:
      - my_own_role
    vars:
      - path: "/tmp/test.txt"
      - content: "Test playbook"
```
</details>

17. В ответ необходимо прислать ссылку на репозиторий с collection

[repo](https://github.com/EvgeshkaSPb/my_own_collection)
