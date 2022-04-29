# Домашнее задание к занятию "7.5. Основы golang"

## Задача 1. Установите golang.
```
student@student-virtual-machine:~$ wget https://go.dev/dl/go1.18.1.linux-amd64.tar.gz
student@student-virtual-machine:~$ sudo tar -xvf go1.18.1.linux-amd64.tar.gz -C /usr/local
student@student-virtual-machine:~$ go version
go version go1.18.1 linux/amd64
```
## Задача 2. Знакомство с gotour.
```
Почитал, поэксперементировал, попытался осознать.
```
## Задача 3. Написание кода.
Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные у пользователя, а можно статически задать в коде. Для взаимодействия с пользователем можно использовать функцию Scanf
```
package main
import "fmt" 

func main() { 
   fmt.Print("Введите количество метров: ") 
   var input float64 
   fmt.Scanf("%f", &input) 

   output  := input * 3.048

   fmt.Println(output) 
}
------------------------------------------------------
student@student-virtual-machine:~/GoLang$ go run feet.go 
Введите количество метров: 2
6.096
```
Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
```
package main
import "fmt"

func main() {

	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}

	min := x[0]
	for _, v := range x {
		if v < min {
			min = v
		}
	}

	fmt.Println(min)
}
------------------------------------------------------
student@student-virtual-machine:~/GoLang$ go run array.go 
9
```
Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть (3, 6, 9, …).
```
package main
import "fmt"

func main() {
	for x := 1; x <= 100; x++ {
		if x%3 == 0 {
			fmt.Printf("%v;", x)
		}
	}
}
----------------------------------------------------
student@student-virtual-machine:~/GoLang$ go run div.go 
3;6;9;12;15;18;21;24;27;30;33;36;39;42;45;48;51;54;57;60;63;66;69;72;75;78;81;84;87;90;93;96;99;
```
