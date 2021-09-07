#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Перем ПараметрыЗапуска;
	Перем Данные;
	Перем РольПолныеПрава;
	Перем Пользователи;
	
#Если ВебКлиент Тогда
	
	Закрыть();

#Иначе
	
	Если ( ПустаяСтрока(ПараметрЗапуска) ) Тогда
		
		ЗавершитьРаботуСистемы(Ложь);
		
	КонецЕсли;

	ПараметрыЗапуска = РазобратьПараметрЗапуска( ПараметрЗапуска );
	Данные = ПолучитьДанные( ПараметрыЗапуска );
	
	РольПолныеПрава = ПолучитьРольПолныеПрава( Данные );
	Пользователи = Данные.Получить( "users" );
	
	Если ( Пользователи <> Неопределено ) Тогда
		
		ЗаменитьПеременныеСредыЗначениями( Пользователи );
		СортироватьСначалаПользователиПолныеПрава( Пользователи, РольПолныеПрава );
		СоздатьПользователей( Пользователи );
		
	КонецЕсли;

	ЗавершитьРаботуСистемы(Ложь);
	
#КонецЕсли

КонецПроцедуры

#КонецОбласти

#Если НЕ ВебКлиент Тогда

#Область СлужебныеПроцедурыИФункции

#Область ПолучениеДанных

&НаКлиенте
Функция РазобратьПараметрЗапуска( Знач ПараметрЗапуска )

	Перем НаборПараметров;
	Перем Результат;
	
	Результат = Новый Соответствие();
	
	НаборПараметров = СтрРазделить( ПараметрЗапуска, ";", Ложь );
	
	Для Каждого Параметр Из НаборПараметров Цикл
		
		ДобавитьПараметр( Результат, Параметр ); 
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ПолучитьДанные( Знач ПараметрыЗапуска )
	
	Перем ПутьКФайлу;
	Перем Файл;
	
	ПутьКФайлу = ПараметрыЗапуска.Получить( "file" );
	
	Если ( ПутьКФайлу = Неопределено ) Тогда
		
		Возврат Неопределено;
	
	КонецЕсли;
		
	Файл = Новый Файл( ПутьКФайлу );
	
	Если ( НЕ Файл.Существует() ) Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Возврат ПрочитатьДанные( Файл );
	
КонецФункции	

&НаКлиенте
Функция ПрочитатьДанные( Знач Файл )
	
	Перем Чтение;
	Перем Результат;
	
	Чтение = Новый ЧтениеJSON();
	Чтение.ОткрытьФайл( Файл.ПолноеИмя );
	Результат = ПрочитатьJSON( Чтение, Истина );
	Чтение.Закрыть();
		
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьПараметр( Результат, Знач Параметр )
	
	Перем Запись;
	
	СОДЕРЖИТ_КЛЮЧ_И_ЗНАЧЕНИЕ = 2;
	
	Запись = СтрРазделить( Параметр, "=", Ложь );
	
	Если ( Запись.Количество() = СОДЕРЖИТ_КЛЮЧ_И_ЗНАЧЕНИЕ ) Тогда
		
		Результат.Вставить( Запись[0], Запись[1] );
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПеременныеСреды

&НаКлиенте
Функция IsLinux()
	
	Перем СистемнаяИнформация;
	Перем ТипыПлатформы;

	СистемнаяИнформация = Новый СистемнаяИнформация();
	
	ТипыПлатформы = Новый Массив();
	ТипыПлатформы.Добавить( ТипПлатформы.Linux_x86 );
	ТипыПлатформы.Добавить( ТипПлатформы.Linux_x86_64 );
	ТипыПлатформы.Добавить( ТипПлатформы.MacOS_x86 );
	ТипыПлатформы.Добавить( ТипПлатформы.MacOS_x86_64 );
	
	Возврат ( ТипыПлатформы.Найти(СистемнаяИнформация.ТипПлатформы) <> Неопределено );

КонецФункции

&НаКлиенте
Функция ПолучитьПеременныеСреды()
	
	Перем ИмяВременногоФайла;
	Перем ПеременныеСреды;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла( "tmp" );

	Попытка
		
		Если ( IsLinux() ) Тогда
			
			КомандаСистемы( "sh -c 'env > " + ИмяВременногоФайла + "'" );
			
		Иначе
			
			КомандаСистемы( "set > """ + ИмяВременногоФайла + """" );
			
		КонецЕсли;

		ПеременныеСреды = ПрочитатьПеременныеСреды( ИмяВременногоФайла );
		
	Исключение
		
		ПеременныеСреды = Новый Соответствие();
		
	КонецПопытки;
	
    УдалитьФайлы( ИмяВременногоФайла );
		
	Возврат ПеременныеСреды;
	
КонецФункции

&НаКлиенте
Функция ПрочитатьПеременныеСреды( Знач ИмяФайла )
	
	Перем Чтение;
	Перем Параметр;
	Перем Результат;

	Чтение = Новый ЧтениеТекста( ИмяФайла, КодировкаТекста.UTF8 );
		
	Результат = Новый Соответствие();
	
	Параметр = Чтение.ПрочитатьСтроку();
	
	Пока ( Параметр <> Неопределено ) Цикл 
		
		ДобавитьПараметр( Результат, Параметр ); 
		Параметр = Чтение.ПрочитатьСтроку();
		
	КонецЦикла;
	
	Чтение.Закрыть();
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция СодержатсяПеременныеСреды( Знач Данные )
	
	Для Каждого Пользователь Из Данные Цикл
		
		Для Каждого Запись Из Пользователь Цикл
			
			Если ( СтрНачинаетсяС(Запись.Значение, "$") ) Тогда
				
				Возврат Истина;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура ЗаменитьПеременныеСредыЗначениями( Данные )
	
	Перем ПеременныеСреды;
	Перем НовоеЗначение;
	
	Если ( НЕ СодержатсяПеременныеСреды(Данные) ) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПеременныеСреды = ПолучитьПеременныеСреды();
	
	Для Каждого Пользователь Из Данные Цикл
		
		Для Каждого Запись Из Пользователь Цикл
			
			Если ( СтрНачинаетсяС(Запись.Значение, "$") И СтрДлина(Запись.Значение) > 1 ) Тогда
				
				НовоеЗначение = ПеременныеСреды.Получить( ВРег(Сред(Запись.Значение, 2)) );
				
				Если ( НовоеЗначение <> Неопределено ) Тогда
					
					Пользователь.Вставить( Запись.Ключ, НовоеЗначение );
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Пользователи

&НаСервереБезКонтекста
Функция ПолучитьПользователя( Знач Имя )
	
	Перем Пользователь;
	
	Пользователь = ПользователиИнформационнойБазы.СоздатьПользователя();
	Пользователь.Имя = Имя;
	Пользователь.ПолноеИмя = Имя;

	Возврат Пользователь;

КонецФункции

&НаКлиенте
Функция ПолучитьРольПолныеПрава( Знач Данные )
	
	Перем Результат;
	
	Результат = Данные.Получить( "full-rights" );
	
	Если ( Результат = Неопределено ) Тогда
		
		Результат = "ПолныеПрава";
		
	КонецЕсли;
		
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура СортироватьСначалаПользователиПолныеПрава( Пользователи, Знач РольПолныеПрава )
	
	Перем Результат;
	Перем Роли;
	Перем Администраторы;
	Перем ОбычныеПользователи;
	
	Результат = Новый Массив();
	Администраторы = Новый Массив();
	ОбычныеПользователи = Новый Массив(); 
	
	Для Каждого Пользователь Из Пользователи Цикл
		
		Роли = Пользователь.Получить( "roles" );
		
		Если ( Роли = Неопределено ) Тогда
			
			ОбычныеПользователи.Добавить( Пользователь );
			
			Продолжить;
			
		КонецЕсли;
		
		Если ( Роли.Найти( РольПолныеПрава ) <> Неопределено ) Тогда
			
			Администраторы.Добавить( Пользователь );
			
		Иначе
			
			ОбычныеПользователи.Добавить( Пользователь );
			
		КонецЕсли;
		
	КонецЦикла;
	
	ДополнитьМассив(Результат, Администраторы);
	ДополнитьМассив(Результат, ОбычныеПользователи);
	
	Пользователи = Результат;
	
КонецПроцедуры	

&НаСервереБезКонтекста
Процедура УстановитьПароль( Пользователь, Знач ДанныеЗаполнения )
	
	Перем Пароль;
	
	Пароль = ДанныеЗаполнения.Получить( "password" );
	
	Если ( Пароль = Неопределено ) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Пользователь.Пароль = Пароль;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьРоли( Пользователь, Знач ДанныеЗаполнения )
	
	Перем Роли;
	
	Роли = ДанныеЗаполнения.Получить("roles");
	
	Если ( Роли = Неопределено ) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Для Каждого Роль Из Роли Цикл
		
		Пользователь.Роли.Добавить( Метаданные.Роли[Роль] );
					
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьЯзык( Пользователь, Знач ДанныеЗаполнения )
	
	Перем КодЯзыка;
	Перем Языки;
	
	КодЯзыка = ДанныеЗаполнения.Получить("lang");
	
	Если ( КодЯзыка = Неопределено ) Тогда
		
		Возврат;
		
	КонецЕсли;

	Языки = Метаданные.Языки;
	
	Для Каждого Язык Из Языки Цикл
		
		Если ( Язык.КодЯзыка <> КодЯзыка ) Тогда
			
			Продолжить;
			
		КонецЕсли; 
		
		Пользователь.Язык = Язык;
					
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьЗначенияПоУмолчанию( Пользователь )
	
	Пользователь.АутентификацияСтандартная = Истина;
	Пользователь.ПоказыватьВСпискеВыбора = Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СоздатьПользователей( Знач Пользователи )
	
	Перем НовыйПользователь;

	Для Каждого ДанныеЗаполнения Из Пользователи Цикл
		
		НовыйПользователь = ПолучитьПользователя( ДанныеЗаполнения.Получить("name") );
		
		УстановитьЗначенияПоУмолчанию( НовыйПользователь );
		УстановитьПароль( НовыйПользователь, ДанныеЗаполнения );
		УстановитьРоли( НовыйПользователь, ДанныеЗаполнения );
		УстановитьЯзык( НовыйПользователь, ДанныеЗаполнения );

		НовыйПользователь.Записать();
		
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

Процедура ДополнитьМассив( МассивПриемник, МассивИсточник )
	
	Для Каждого Значение Из МассивИсточник Цикл
		
		МассивПриемник.Добавить( Значение );
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли