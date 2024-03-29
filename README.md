# Описание

Генерация данных при создании пустой базы данны для целей CI/CD с помощью внешней обработки при запуске в режиме "Предприятие" (см. [пример разработки в своей ветке](https://github.com/astrizhachuk/bootstrap-1c#пример-разработки-в-своей-ветке)).

[См. также](https://github.com/astrizhachuk/bootstrap-1c/tree/master/tools)

## Требования

* Платформа 1С не ниже 8.3.6;
* Обработка не предназначена для запуска в веб-клиенте;

## Инструменты разработки

* Разработка ведется в [EDT](https://releases.1c.ru/project/DevelopmentTools10).
* Платформа 1С не ниже 8.3.10.2667;

## Параметры

Параметры обработки передаются через аргумент `/C` при её запуске в пакетном режиме через `/Execute`. Каждая пара параметров разделяется символом "`;`". Ключ и значение параметра разделяются символом "`=`".

### Возможные значения

* file - путь к файлу с данными создаваемых пользователей (см. пример).

### Пример "users.json"

```json
{
    "full-rights": "ПолныеПрава",
    "users": [
        {
            "name": "Иванов_И_И",
            "roles": [
                "Роль1",
                "Роль2"
            ],
            "password": "12345"
        },
        {
            "name": "Петров_П_П",
            "roles": [
                "Роль1",
                "Роль2"
            ],
            "password": "$ONEC_PASSWORD"
        },
        {
            "name": "Администратор",
            "roles": [
                "ПолныеПрава"
            ]
        },
        {
            "name": "Сидоров_С_С",
            "roles": [
                "Роль2"
            ],
            "lang": "ru"
        },
        {
            "name": "Буржуй_Б_Б",
            "lang": "en"
        },
        {
            "name": "Патриот_П_П",
            "lang": "ru"
        }
    ]
}
```

* full-rights - (необязательный) имя роли с полными правами (как в конфигураторе), если в списке пользователей добавляются как администраторы, так и обычные пользователи (чтобы исключить ошибку "в базе не осталось пользователей без административных прав");
* users - добавляемые пользователи:

----

* name - имя пользователя (краткое имя пользователя при заведении его в конфигураторе);
* roles - массив доступных пользователю ролей (имя роли как в метаданных);
* lang - код языка пользователя (как указано в метаданных);
* password - пароль пользователя, поддерживаются переменные окружения (в формате `linux`);
