# Домашнее задание к занятию "10.01. Зачем и что нужно мониторить"

## Обязательные задания

1. Вас пригласили настроить мониторинг на проект. На онбординге вам рассказали, что проект представляет из себя 
платформу для вычислений с выдачей текстовых отчетов, которые сохраняются на диск. Взаимодействие с платформой 
осуществляется по протоколу http. Также вам отметили, что вычисления загружают ЦПУ. Какой минимальный набор метрик вы
выведите в мониторинг и почему?

> Решение:
> ### Для мониторинга работоспособности оборудования.
> Проводится для оценки состояния и нагрузки оборудования.
>  - Мониторинг CPU. 
>    - Для монитооринга CPU используется использовать общее значение нагрузки. Можно дополнительно разбить на доп. метрики.
>        - CPU idle (Простой процессора)
>        - CPU Load Average (нагрузка на ядра)
> - Мониторинг RAM
>    - Количество использованной памяти.
>    - Колиество свободной памяти.
> - Мониторинг HDD
>    - Состояние дисков (smart)
>    - Свободное место на дисках в %
>    - Нагрузка на диск (iostat)
> - Мониторинг Network интерфейсов
>    - Загруженность сетевого интерфейса
> ### Для мониторинга работоспособности ПО.
> Проводится для оценки работоспособности самой платформы.
> - Общее количество http\https запросов
> - Количество ответов по кодам (400, 200, 500) возможно в %.
> - Количество запросов с высоким временем ответа (выше заданого)
> ### Для мониторинга Безопасности.
> Базовые метрики безопасности.
> - Неудачные авторизации.
> - Актуальности сертификатов.
> ### Для бизнес мониторинга.
> Для планирования развития платформы и загруженность системы в целом.
> - Количество пользователей в системе.
> - Количество запросов на отчёты в течение 5 минут.
> - Количество выполненных  в течение 5 минут.
> - Среднее время выполнения запроса на прдоставление отчета в течение 5 минут.



2. Менеджер продукта посмотрев на ваши метрики сказал, что ему непонятно что такое RAM/inodes/CPUla. Также он сказал, 
что хочет понимать, насколько мы выполняем свои обязанности перед клиентами и какое качество обслуживания. Что вы 
можете ему предложить?

> Решение:  
> Я предложу выделить ключевые метрики SLI и вывести на мониторинг значения соответствия метрик согласованным целям SLO.  
> Так-же можно добавить отчеты соответсвия SLO за периоды времени.

3. Вашей DevOps команде в этом году не выделили финансирование на построение системы сбора логов. Разработчики в свою 
очередь хотят видеть все ошибки, которые выдают их приложения. Какое решение вы можете предпринять в этой ситуации, 
чтобы разработчики получали ошибки приложения?

> Решение:  
> - Возможно использовать скрипты для проверки логов на наличие ошибок и отправлять резальтаты на почту разработчикам и\или общий ресурс.
> - Развернуть бесплатную  мониторинга логов (Sentry, ELK) и мониторить ошибки в ней.


3. Вы, как опытный SRE, сделали мониторинг, куда вывели отображения выполнения SLA=99% по http кодам ответов. 
Вычисляете этот параметр по следующей формуле: summ_2xx_requests/summ_all_requests. Данный параметр не поднимается выше 
70%, но при этом в вашей системе нет кодов ответа 5xx и 4xx. Где у вас ошибка?

> Решение:  
> Скорее всего проблема в неправильной формуле, которая не учитывает 1хх и 3хх коды. Формула должна быть такой:  
> (summ_2xx_requests + summ_1xx_requests + summ_3xx_requests)/summ_all_requests
