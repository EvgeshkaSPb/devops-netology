# Домашнее задание к занятию "8.4 Работа с Roles"
```
В рамках домашнего задания, был переработан playbook из задания 8.3.
Данный playbook устанавливает и настраивает сервисы clickhouse, lighthouse(+nginx) и vector, на 3х ВМ.
Создание ВМ осуществляется при помощи terraform (дирктория yc-terraform).

1.Согласно заданию были созданы 2 отдельных репозитория для:
  [Lighthouse](https://github.com/EvgenAnsible1/lighthouse-role "ссылка")
  [Vector](https://github.com/EvgenAnsible1/vector-role "ссылка")
2.В данных репозиториях размещены соответствующие роли.
3.Playbook site.yml настроен на использование roles.
4.Для загрузки ролей в Playbook используется requirements.yml.
```
