# Домашнее задание к занятию "10.03. Grafana"

### Задание 1
Используя директорию [help](./help) внутри данного домашнего задания - запустите связку prometheus-grafana.

Зайдите в веб-интерфейс графана, используя авторизационные данные, указанные в манифесте docker-compose.

Подключите поднятый вами prometheus как источник данных.

Решение домашнего задания - скриншот веб-интерфейса grafana со списком подключенных Datasource.

### Ответ

![screen1](https://github.com/EvgeshkaSPb/devops-netology/blob/main/10_3/files/screen1.jpg)

## Задание 2
Изучите самостоятельно ресурсы:
- [promql-for-humans](https://timber.io/blog/promql-for-humans/#cpu-usage-by-instance)
- [understanding prometheus cpu metrics](https://www.robustperception.io/understanding-machine-cpu-usage)

Создайте Dashboard и в ней создайте следующие Panels:
- Утилизация CPU для nodeexporter (в процентах, 100-idle)
- CPULA 1/5/15
- Количество свободной оперативной памяти
- Количество места на файловой системе

Для решения данного ДЗ приведите promql запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.

### Ответ
Утилизация CPU для nodeexporter (в процентах, 100-idle)
```
avg by(instance)(rate(node_cpu_seconds_total{job="nodeexporter",mode="idle"}[$__rate_interval])) * 100
```
CPULA 1/5/15
```
avg by (instance)(rate(node_load1{}[$__rate_interval]))
avg by (instance)(rate(node_load5{}[$__rate_interval]))
avg by (instance)(rate(node_load15{}[$__rate_interval]))
```
Количество свободной оперативной 
> Дополнинил графиком используемой памяти.
```
node_memory_MemFree_bytes{instance="nodeexporter:9100"}
node_memory_MemTotal_bytes{instance="nodeexporter:9100"} - node_memory_MemFree_bytes{instance="nodeexporter:9100"} - node_memory_Cached_bytes{instance="nodeexporter:9100"} - node_memory_Buffers_bytes{instance="nodeexporter:9100"}
```
Количество места на файловой системе
```
node_filesystem_size_bytes{fstype="ext4",instance="nodeexporter:9100"}
node_filesystem_free_bytes{fstype="ext4",instance="nodeexporter:9100"}
```
![screen2](https://github.com/EvgeshkaSPb/devops-netology/blob/main/10_3/files/screen2.jpg)

## Задание 3
Создайте для каждой Dashboard подходящее правило alert (можно обратиться к первой лекции в блоке "Мониторинг").

Для решения ДЗ - приведите скриншот вашей итоговой Dashboard.

### Ответ

![screen3](https://github.com/EvgeshkaSPb/devops-netology/blob/main/10_3/files/screen3.jpg)


## Задание 4
Сохраните ваш Dashboard.

Для этого перейдите в настройки Dashboard, выберите в боковом меню "JSON MODEL".

Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.

В решении задания - приведите листинг этого файла.

### Ответ

[Grafana.json](https://github.com/EvgeshkaSPb/devops-netology/blob/main/10_3/files/grafana.json)



