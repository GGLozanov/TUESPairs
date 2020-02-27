# TUESPairs
Pairing up our favourite peers with their favourite teachers.
## 1.	 Идея
Мобилно + WEB приложение за правене на съответствия между дипломанти от ТУЕС и дипломни ръководители.
 
## 2.	 Технологии 
Flutter (Google Framework), Dart, Android Studio (Java-based SDK), React (JS Framework), Firebase (Google-powered server).

## 3.	 Features
 * 4 модула - дипломанти и ръководители, идеи, тагове:
    * Дипломанти - име, снимка, описание, технологии, които харесва/владее (тагове), статус (зает/незает), описание на конкретна идея (инстанция на 1 модул)
    * Ръководители - име, снимка, описание, технологии, които владеят (тагове), избрани дипломанти (списък от дипломанти)
    * Идеи - име, описание, може би снимка; Embedded/Software.
    * Тагове - име (+цвят). Ще има предефинирани, но в Settings биха могли да бъдат добавяни и създавани нови.
    * Рейтинг (оценка на дипломант)
 * Регистрация + логин страница/View за дипломанти и ръководители. Ръководители могат да се регистрират с тайна парола (напр.) или да има approval метод.
 * CRUD за модулите (Settings меню)
 * Страница/View за match на ръководител с дипломант (и обратно). Ръководител и дипломант ще match-ват спрямо брой на еднакви тагове (map от брой еднакви тагове дипломант<->ръководител frequency и обратно).
 * Logout опция.
 * При match м/у дипломант и ръководител се променя статуса на двамата, махат се от списъка за свободни ръководители/дипломанти. Match ще бъде или ако поне един от двамата избере едния, или ако двамата се изберат.
 * *Possible Feature* - чат м/у дипломант и ръководител
 * Един Database за WEB и Mobile - Firebase сървър, който изпраща информация към Flutter и React приложението.

## 4.	 Milestones
  * Първи Milestone - CRUD операции; Match страница (и на WEB, и на Mobile; възможно е с някой незавършени features).
  * Втори Milestone - Завършена Match страница, CRUD, връзката м/у WEB и Mobile да бъде осъществена, чат (ако не остане possible feature).

## 5.	 Final
  * CRUD операции за всички модули
    *	Регистрация
    *	Логин
    * Settings за дипломант/ръководител, където става CRUD и за тагове/идеи  (таговете/идеи ще се edit-ват и добавят спрямо потребителя).
  *	Match страница/View
  *	Чат страница/View (possible)
  * Конфигурирани логове за Android Studio и отделни за WEB
  * Unit Tests

## 6.	 Branching Strategy
Git Flow
## 7.	Database
Firebase и, by extension, Firestore.
## 8.	 Авторизация 
Superuser директор, който да одобрява регистрация за ръководител, среден успех и т.н.
