# encoding: UTF-8
# language: ru

#Readme
# Данный тест - проверка навыков работы с REST API
# Мы используем Gem RestClient
# Для облегчения работы в тесте есть обертка над этим гемом features/support/helpers/rest_wrapper.rb

# Ваша задача
# 1. Реализовать шаг удаления пользователя по логину ( логин - уникальный параметр для пользователя)
# 2. Реализовать шаг изменения доступных параметров пользователя по логину
# 3. Провести исследовательское тестирование работы реализованных REST API сервисов (независимо и в связках)
@testRESTAPI
Функция: REST API


@testGETPos
   Структура сценария: Положительные проверки метода GET

    Дано получаю информацию о пользователях
    И добавляю пользователя с случайным логином "<random_login>" именем "<name>" фамилией "<surname>" паролем "<password>" значением поля active "<active_input>"
    И нахожу пользователя с случайным добавленным логином "<random_login>" в прошлом шаге в списке пользователей

    Примеры:
    | random_login | name | surname | password | active_input |
    | QA_Micro_Test_Active_ | Kartofel | Great | BigM0n67 | 1 |
    | QA_Micro_Test_Active_ | Kartofel | Great | BigM0n67 | 0 |

@testGETNeg 
   Сценарий: Негативная проверка метода GET

    Дано получаю информацию о пользователях
    И проверяю обработку несуществующего ID равного 6655
    Тогда получаю ошибку 404 для несуществующего ID равного 6655 

   
  
@testPOSTPos
  Структура сценария: Позитивная проверка метода POST

    Дано получаю информацию о пользователях
    И проверяю наличие логина "<login>" в списке пользователей
    И удаляю пользователя по логину "<login>"
    И добавляю пользователя с логином "<login>" именем "<name>" фамилией "<surname>" паролем "<password>" значением поля active "<active_input>"
    И нахожу пользователя с логином "<login>" в списке пользователей

    Примеры:
    | login | name | surname | password | active_input |
    | QA_Micro_Test_Active_5 | Kartofel | Great | BigM0n67 | 1 |
    | QA_Micro_Test_Active_8 | Kartofel | Great | BigM0n67 | 0 |
    | QA_Micro_Test_Active_15 | Kartofel | Great | BigM0n67 | 45 |
    | QA_Micro_Test_Active_9 | Kartofel | Great | BigM0n67 | -1 |
    | QA_Micro_Test_Active_6 | Kartofel | Great | BigM0n67 | 1 | 



@testPOSTNeg
  Структура сценария: Негативная проверка метода POST

    Дано получаю информацию о пользователях
    И проверяю отсутствие логина "<login>" в списке пользователей
    И добавляю пользователя с логином "<login>" именем "<name>" фамилией "<surname>" паролем "<password>" значением поля active "<active_input>"
    И нахожу пользователя с логином "<login>" в списке пользователей

    Примеры:
    | login | name | surname | password | active_input |
    | QA_Micro_Test_Active_7 | Kartofel | Great | 33333333333333333333333333333333333333333333333333 | 1 |
    | QA_Micro_Test_Active_10 | Kartofel | Great | BigM0n67 | abc |



@testPUTPos
  Структура сценария: Негативная проверка метода PUT

    Дано получаю информацию о пользователях
    И проверяю наличие логина "<login>" в списке пользователей
    И изменяю у пользователя с логином "<login>" имя на "<name>" фамилию на "<surname>" пароль на "<password>" и значение поля active на "<active_input>"
    И проверяю изменения по логину "<login>"

    Примеры:
    | login | name | surname | password | active_input |
    | QA_Micro_Test_Active_0 | Kartofel | Oguzok | Mann69 | 1 |
    | QA_Micro_Test_Active_0 | Kartofel | Иванов | Mann69 | 1 |
    | QA_Micro_Test_Active_0 | Kartofel | Oguzok | Mann69 | 0 |
    | QA_Micro_Test_Active_0 | Kartofel | Oguzok | Mann69 | -1 |
    | QA_Micro_Test_Active_0 | Kartofel | Oguzok | Mann69 | 2 |

@testPUTNeg
  Структура сценария: Позитиивная проверка метода PUT

    Дано получаю информацию о пользователях
    И изменяю у пользователя с логином "<login>" имя на "<name>" фамилию на "<surname>" пароль на "<password>" и значение поля active на "<active_input>"
    И проверяю изменения по логину "<login>"

    Примеры:

    | login | name | surname | password | active_input |
    | QA_Micro_Test_Active_0 | Kartofel | Oguzok | Mann69 | heh |
    | QA_Micro_Test_Active_33 | Kartofel | Oguzok | Mann69 | 1 | 


@testDELETEPos
  Сценарий: Позитивная проверка метода DELETE

    И проверяю отсутствие логина QA_Micro_Test_Active_4 в списке пользователей 
    И добавляю пользователя с логином QA_Micro_Test_Active_4 именем "Kartofel" фамилией "Great" паролем "BigM0n67" значением поля active "1"
    И удаляю пользователя по логину QA_Micro_Test_Active_4
    И проверяю отсутствие логина QA_Micro_Test_Active_4 в списке пользователей 


@testDELETENeg
  Сценарий: Негативная проверка метода DELETE 

    И проверяю отсутствие логина "QA_Micro_Test_Active_65" в списке пользователей 
    И удаляю пользователя по логину "QA_Micro_Test_Active_65"


@testREST_INTEGR
 Сценарий: Работа с пользователями через REST API

    Дано получаю информацию о пользователях
    И проверяю наличие логина QA_Micro_Test_Active_2 в списке пользователей 
    И удаляю пользователя по логину QA_Micro_Test_Active_2
    И добавляю пользователя с логином QA_Micro_Test_Active_2 именем Kartofel фамилией Great паролем BigM0n67 значением поля active 1
    И изменяю у пользователя с логином QA_Micro_Test_Active_2 имя на Kartofel фамилию на Oguzok пароль на LOL95 и значение поля active на 1
    И проверяю изменения по логину QA_Micro_Test_Active_2
