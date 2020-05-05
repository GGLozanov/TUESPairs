![](https://cdn.discordapp.com/attachments/570237847672586270/707345183708151888/68747470733a2f2f63646e2e646973636f72646170702e636f6d2f6174746163686d656e74732f3537303233373834373637.png)

# Pairing up our favourite peers with their favourite teachers.

Latest build status: [![Latest Build Status](https://app.bitrise.io/app/65f7e81df01f66b6/status.svg?token=N6j31UVCWpUMdM9_P9tSZQ)](https://app.bitrise.io/app/65f7e81df01f66b6)

master/release: [![master Build Status](https://app.bitrise.io/app/65f7e81df01f66b6/status.svg?token=N6j31UVCWpUMdM9_P9tSZQ&branch=master)](https://app.bitrise.io/app/65f7e81df01f66b6)

Mobile: ![[Mobile Build Status]](https://app.bitrise.io/app/65f7e81df01f66b6/status.svg?token=N6j31UVCWpUMdM9_P9tSZQ&branch=Mobile)

## 1.	 Идея
Мобилно + WEB приложение за правене на съответствия между дипломанти от ТУЕС и дипломни ръководители.

## 2. Как да си сваля и използвам проекта?

### 2.1 Мобилнo Приложение

**Засега тегленето на приложението е неосъществимо поради проблеми с реализирането на apk-та. Това ще бъде оправено скоро. За повече информация, консултирайте авторите на приложението докато fix е намерен.**

### Инструкции за сваляне
1) Отидете на полето на този сайт (това репо), където се състои информацията за проекта (трябва да пише "къмити"/"commits", "бранчове"/"branches") и намерете таба, където са последните версии ("рилийзес"/"releases")
2) Натиснете този таб
3) Намерете най-новата версия на приложението (v1.0, v.2.0, т.н.)
4) Кликнете върху нея
5) Изтеглете файла с extension apk и изчакайте да се изтегли

### Инструкции за инсталация
1) Намерете изтегленото apk (най-вероятно е някъде в известията на телефона ви е изписало)
2) Натиснете го
3) Потвърдете всички стъпки за инсталация и инсталирайте приложението

### Инструкции за стартиране на приложението
1) Намерете приложението на главния екран на телефона си
2) Натиснете го

### 2.2 WEB-сайт
Отидете на хостнатия линк: (TBA)

Или си клонирайте репото и го пуснете на localhost чрез `npm i` и после `npm start`.

## 3. Автори
* **Георги Лозанов** - Mobile lead програмист - [katapultman](https://github.com/katapultman)
* **Мариян Бицов** - WEB lead програмист, дизайнер - [marianbitsov23](https://github.com/marianbitsov23)
* **Мартин Симов** - WEB и Mobile програмист, дизайнер - [martinsimov10a19](https://github.com/martinsimov10a19)

## 4.	 Технологии 
Flutter (Google SDK), Dart, Android Studio (Java-based SDK w/ IntelliJ-based IDE), React (JS Framework), Firebase (Google-powered server).

## 5.	 Features
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
 * Чат м/у дипломант и ръководител
 * Един Database за WEB и Mobile - Firebase сървър, който изпраща информация към Flutter и React приложението.

## 6.	 Milestones
  * Първи Milestone - CRUD операции; Match страница (и на WEB, и на Mobile; възможно е с някой незавършени features).
  * Втори Milestone - Завършена Match страница, CRUD, връзката м/у WEB и Mobile да бъде осъществена, чат.

## 7.	 Final
  * CRUD операции за всички модули
    *	Регистрация
    *	Логин
    * Settings за дипломант/ръководител, където става CRUD и за тагове/идеи  (таговете/идеи ще се edit-ват и добавят спрямо потребителя).
  *	Match страница/View
  *	Чат страница/View (possible)
  * Конфигурирани логове за Android Studio и отделни за WEB
  * Unit Tests

## 8.	 Branching Strategy
Git Flow разделен на няколко бранча:
 * master - само и единствено стабилен код готов за deployment
 * Mobile/Web (development) - development бранчове за разработка на general purpose features и мърджване на feature бранчове
 * Development-Feature_Name - feature бранч за разработка на специфични, large-scale features, който се мърджва с development
 * Development-Hotfix_Name - hotfix бранч за оправяне на специфични части от development бранча, който се мърджва с master
  
[Git Flow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) е избрана заради възможността за колаборация по еднакви feature-и със съотборници и обезопасяването на стабилната част от кода от бъгове и конфликти.
## 9.	Database
Firebase и, by extension, Firestore database и Firebase Storage.
## 10.	 Авторизация 
Superuser директор, който да одобрява регистрация за ръководител, среден успех и т.н.
