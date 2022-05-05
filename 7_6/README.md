# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

## Задача 1.
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: https://github.com/hashicorp/terraform-provider-aws.git. 
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.
Найдите, где перечислены все доступные resource и data_source, приложите ссылку на эти строки в коде на гитхабе.
```
resource
https://github.com/hashicorp/terraform-provider-aws/blob/29a44d1f45cad3a890553c5fa2145bae0de46210/internal/provider/provider.go#L417
data_source
https://github.com/hashicorp/terraform-provider-aws/blob/8e4d8a3f3f781b83f96217c2275f541c893fec5a/aws/provider.go#L169
```
Для создания очереди сообщений SQS используется ресурс aws_sqs_queue у которого есть параметр name.
С каким другим параметром конфликтует name? Приложите строчку кода, в которой это указано.
```
ConflictsWith: []string{"name_prefix"}
https://github.com/hashicorp/terraform-provider-aws/blob/ad0cf62929dd5700d00db0222c5da14212d17266/internal/service/sqs/queue.go#L87 
```
Какая максимальная длина имени?
Какому регулярному выражению должно подчиняться имя?
```
Максимальная длинна имени - 80 символов.
Если fifoQueue то - 75 символов+.fifo
```
Какому регулярному выражению должно подчиняться имя?
```
Если очередь fifo
re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,75}\.fifo$`) - символы английского алфавита обоих регистров, цифры, нижнее подчеркивание, дефис. Длинна имени до 75 символов и заканичвается на ".fifo".

для остальных имен
кe = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,80}$`) - символы английского алфавита обоих регистров, цифры, нижнее подчеркивание, дефис. Длинна имени до 80 символов.

https://github.com/hashicorp/terraform-provider-aws/blob/ad0cf62929dd5700d00db0222c5da14212d17266/internal/service/sqs/queue.go#L424
```
