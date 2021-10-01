# devops-netology
     1.	Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.

Решение: Коммит найден с помощью команды “git show aefea”

Ответ: commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545

Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>

Date:   Thu Jun 18 10:29:58 2020 -0400

Update CHANGELOG.md

     2.	Какому тегу соответствует коммит 85024d3?

Решение: Найдено с помощью команды “git tag --points-at 85024d3”

Ответ: v0.12.23

     3.	Сколько родителей у коммита b8d720? Напишите их хеши.

Решение: Найдено с помощью команды “ git show --pretty=%P b8d720”

(опция –pretty меняет формат вывода, а %P Отдает хеш родительских коммитов)

Ответ: 

56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b

У коммита 2 родителя т.к. это мерж коммит.

     4.	Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.

Решение: Найдено с помощью команды git log v0.12.23..v0.12.24 --pretty=oneline (--pretty=oneline что бы в выводе были только хеши и комментарии).

Ответ:

33ff1c03bb960b332be3af2e333462dde88b279e (tag: v0.12.24) v0.12.24

b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links

3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md

6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is unreachable

5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting started guide's old location

06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md

d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terraform login on Windows

4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md

dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md

225466bc3e5f35baa5d07197bbc079345b77525e Cleanup after v0.12.23 release

К сожалению, в вывод команды попадает и коммит с тэгом v0.12.24, я скопировал полный вывод команды, хотя для правильности ответа, возможно, стоило его убрать.

     5.	Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).

Решение: git log -S 'func providerSource(' --pretty=oneline

Для вывода использовал поиск по логу т.к. он выводит хеш коммита с комментарием. Не нашел как искать по рандомным значением в скобках, по этому использовал одну. В вводе был только один коммит.

Ответ:

8c928e83589d90a031f811fae52a81be7153e82f main: Consult local directories as potential mirrors of providers

     6.	Найдите все коммиты в которых была изменена функция globalPluginDirs.

Решение: Аналогично предыдущему git log -S globalPluginDirs --pretty=oneline

Ответ:

35a058fb3ddfae9cfee0b3893822c9a95b920f4c main: configure credentials from the CLI config file

c0b17610965450a89598da491ce9b6b5cbd6393f prevent log output during init

8364383c359a6b738a436d1b7745ccdce178df47 Push plugin discovery down into command package

     7.	Кто автор функции synchronizedWriters?
    Я не нашел простого решения данной задачи. Git blame и git grep выдавали пустой результат.

    1.	Ищем коммит у которого самое раннее появления данной функции

        git log -S synchronizedWriters –oneline

    2.	Переключаемся на самый ранний из найденых коммитов.

        git checkout 5ac311e2a

    3.	Производим поиск нужной фукции

        git grep 'func synchronizedWriters'

    4.	Узнаем кто создал файл

        git blame synchronized_writers.go

    Ответ:

    Martin Atkins 2017-05-03 16:25:41





