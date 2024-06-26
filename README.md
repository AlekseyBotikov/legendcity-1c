# Интеграция Город Легенд с 1С:Предприятие 8
[![Common Changelog](https://common-changelog.org/badge.svg)](https://common-changelog.org)

> [Город Легенд](https://legendcity.ru) это единая программа лояльности. По **Карте Легенда** доступны скидки, Легенд Баллы, бонусы и подарки от любимых заведений и онлайн-магазинов, всё по одной карте.


Интеграция выполнена в виде модуля расширения для типовых конфигураций:
* 1С:Розница 8 - версии 2.2, 2.3
* 1С:Управление торговлей 8
* 1С:Управление нашей фирмой 8

Режим совместимости платформы 8.3.12


Обмен ведётся с **Legendcity Public API** https://api.legendcity.ru/v4/

Используется *внешняя система лояльности*, расчет списании/начеслении бонусов и скидок ведется в **1С:Предприятие 8**.


## Разработка

В репозитории хранятся исходные коды модуля расширения. 

После загрузки исходного кода на локальный диск и после каждого обновления из главной ветки репозитория выполняется "Конфигурация -> Расширения Конфигурации -> Загрузить конфигурацию из файлов".

По окончанию работы с расширением, выполняется "Выгрузить конфигурацию в файлы".

Значимые изменения отправляются как pull request в главную ветку репозитория.

.cfe файлы собираются автоматически из исходного кода.

История изменений хранится в [CHANGELOG.md](CHANGELOG.md) файле в формате [Common Changelog](https://common-changelog.org)

## Лицензия

Текст лицензии в файле [LICENSE.txt](LICENSE.txt)
