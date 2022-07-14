# Домашнее задание к занятию "09.01 Жизненный цикл ПО"

## Подготовка к выполнению
1. Получить бесплатную JIRA
2. Настроить её для своей "команды разработки"
3. Создать доски kanban и scrum

## Основная часть

В рамках основной части необходимо создать собственные workflow для двух типов задач: bug и остальные типы задач. Задачи типа bug должны проходить следующий жизненный цикл:

1. Open -> On reproduce
2. On reproduce -> Open, Done reproduce
3. Done reproduce -> On fix
4. On fix -> On reproduce, Done fix
5. Done fix -> On test
6. On test -> On fix, Done
7. Done -> Closed, Open
8. Остальные задачи должны проходить по упрощённому workflow:

1. Open -> On develop
2. On develop -> Open, Done develop
3. Done develop -> On test
4. On test -> On develop, Done
5. Done -> Closed, Open
Создать задачу с типом bug, попытаться провести его по всему workflow до Done. Создать задачу с типом epic, к ней привязать несколько задач с типом task, провести их по всему workflow до Done. При проведении обеих задач по статусам использовать kanban. Вернуть задачи в статус Open. Перейти в scrum, запланировать новый спринт, состоящий из задач эпика и одного бага, стартовать спринт, провести задачи до состояния Closed. Закрыть спринт.

Если всё отработало в рамках ожидания - выгрузить схемы workflow для импорта в XML. Файлы с workflow приложить к решению задания.

## Решение

Созданы 2 схемы workflow

1 [для работы с bug](https://github.com/EvgeshkaSPb/devops-netology/blob/main/9_1/HW91_Bug.xml)   

2 [для остальных типов задач](https://github.com/EvgeshkaSPb/devops-netology/blob/main/9_1/HW91_simple.xml)

Для Kanban, в целях эксперимента, добавлены 2 дополнительных столбца "ON TEST" и "CLOSE".
![Kanban board](https://github.com/EvgeshkaSPb/devops-netology/blob/main/9_1/Kanban-board.jpg)

Проведена задача bug по всему workflow
![Bug-kanban](https://github.com/EvgeshkaSPb/devops-netology/blob/main/9_1/bug-kanban.jpg)

Проведены задачи epic по всему workflow
![epic-kanban](https://github.com/EvgeshkaSPb/devops-netology/blob/main/9_1/Epic-kanban.jpg)

Все задачи возвращены в статус open, создан спринт и все задачи проведены до статуса closed
![sprint](https://github.com/EvgeshkaSPb/devops-netology/blob/main/9_1/scrum-sprint.jpg)
![sprint-closed](https://github.com/EvgeshkaSPb/devops-netology/blob/main/9_1/Scrum-task1-closed.jpg)
