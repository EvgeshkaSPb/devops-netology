# Домашнее задание к занятию "10.02. Системы мониторинга"

## Обязательные задания

1. Опишите основные плюсы и минусы pull и push систем мониторинга.

> ### Ответ:

> Push модель:  
> Плюсы  
> Гибкая настройка пакетов даных с метриками. На каждом агенте можем выбрать частоту и объем.  
> Возможность собирать практически любые метрики, подставляя скрипты в User параметр.  
> Простая настройка репликации в разные системы мониторинга. Агент отправляет на определенный сервер или список серверов.  
> Возможность отправлять по UDP.  
> Получение данных сразу по возникновению.    
> Минусы  
> Передача данных в открытом виде по сети.  
> Требутеся открытие порта сервера "наружу".  
> Возможно потеря данных в случае недоступности сервера.  
>
> Pull модель:  
> Плюсы  
> Контроль подлинности данных. (Получаем только оттуда, откуда запрашиваем.)  
> Контроль над метриками с единой точки, возможность конеккта по SSL к агентам.  
> Возможность получать данные вне системы мониторига по http.    
> Минусы  
> Требуется хорошая, стабльная связь с агентами.  
> Данные появляются только в момент опроса клиента.  
> Если клиент был не доступен во время опроса - данных не появится.  


2. Какие из ниже перечисленных систем относятся к push модели, а какие к pull? А может есть гибридные?

    - Prometheus 
    - TICK
    - Zabbix
    - VictoriaMetrics
    - Nagios

> ### Ответ:

> Prometheus - Pull (Push с Pushgateway)  
> TICK - Push  
> Zabbix - Push (Pull с Zabbix Proxy)  
> VictoriaMetrics - Гибридная  
> Nagios - Pull  


3. Склонируйте себе [репозиторий](https://github.com/influxdata/sandbox/tree/master) и запустите TICK-стэк, 
используя технологии docker и docker-compose.

В виде решения на это упражнение приведите выводы команд с вашего компьютера (виртуальной машины):

    - curl http://localhost:8086/ping
    - curl http://localhost:8888
    - curl http://localhost:9092/kapacitor/v1/ping

А также скриншот веб-интерфейса ПО chronograf (`http://localhost:8888`). 

> ### Ответ: 

```
student@student-virtual-machine:~/monitor_hw/10_2$ curl http://localhost:8086/ping
student@student-virtual-machine:~/monitor_hw/10_2$ curl http://localhost:8888
<!DOCTYPE html><html><head><meta http-equiv="Content-type" content="text/html; charset=utf-8"><title>Chronograf</title><link rel="icon shortcut" href="/favicon.fa749080.ico"><link rel="stylesheet" href="/src.9cea3e4e.css"></head><body> <div id="react-root" data-basepath=""></div> <script src="/src.a969287c.js"></script> </body></html>
student@student-virtual-machine:~/monitor_hw/10_2$ curl http://localhost:9092/kapacitor/v1/ping
```

![Screenshot](https://github.com/EvgeshkaSPb/devops-netology/blob/main/10_2/screenshot/screen1.jpg)

P.S.: если при запуске некоторые контейнеры будут падать с ошибкой - проставьте им режим `Z`, например
`./data:/var/lib:Z`

4. Перейдите в веб-интерфейс Chronograf (`http://localhost:8888`) и откройте вкладку `Data explorer`.

    - Нажмите на кнопку `Add a query`
    - Изучите вывод интерфейса и выберите БД `telegraf.autogen`
    - В `measurments` выберите mem->host->telegraf_container_id , а в `fields` выберите used_percent. 
    Внизу появится график утилизации оперативной памяти в контейнере telegraf.
    - Вверху вы можете увидеть запрос, аналогичный SQL-синтаксису. 
    Поэкспериментируйте с запросом, попробуйте изменить группировку и интервал наблюдений.

Для выполнения задания приведите скриншот с отображением метрик утилизации места на диске 
(disk->host->telegraf_container_id) из веб-интерфейса.

> ### Ответ: 

![Screenshot2](https://github.com/EvgeshkaSPb/devops-netology/blob/main/10_2/screenshot/screen2.jpg)


5. Изучите список [telegraf inputs](https://github.com/influxdata/telegraf/tree/master/plugins/inputs). 
Добавьте в конфигурацию telegraf следующий плагин - [docker](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/docker):
```
[[inputs.docker]]
  endpoint = "unix:///var/run/docker.sock"
```

Дополнительно вам может потребоваться донастройка контейнера telegraf в `docker-compose.yml` дополнительного volume и 
режима privileged:
```
  telegraf:
    image: telegraf:1.4.0
    privileged: true
    volumes:
      - ./etc/telegraf.conf:/etc/telegraf/telegraf.conf:Z
      - /var/run/docker.sock:/var/run/docker.sock:Z
    links:
      - influxdb
    ports:
      - "8092:8092/udp"
      - "8094:8094"
      - "8125:8125/udp"
```

После настройке перезапустите telegraf, обновите веб интерфейс и приведите скриншотом список `measurments` в 
веб-интерфейсе базы telegraf.autogen . Там должны появиться метрики, связанные с docker.

> ### Ответ: 

![Screenshot3](https://github.com/EvgeshkaSPb/devops-netology/blob/main/10_2/screenshot/screen3.jpg)
