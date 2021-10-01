﻿
#Область РегламентныеЗадания

Процедура ВыгрузитьИзмененияБонусовРегламентноеЗадание() Экспорт

	ВыгрузитьИзмененияБонусов(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

Процедура ЗарегистрироватьИзменения(Документ, БонуснаяКарта, Сумма) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЖурналВыгрузки = РегистрыСведений.пд_БонусныеНачисленияКВыгрузке.СоздатьНаборЗаписей();
	ЖурналВыгрузки.Отбор.Документ.Установить(Документ);
		
	Если ЗначениеЗаполнено(БонуснаяКарта) Тогда
		ЖурналВыгрузки.Отбор.БонуснаяКарта.Установить(БонуснаяКарта);	
	КонецЕсли;
	
	ЖурналВыгрузки.Прочитать();
	
	Если ЖурналВыгрузки.Количество() > 0 Тогда
		
		Для Каждого Запись Из ЖурналВыгрузки Цикл
			
			Запись.Выгружено = Ложь;
			
			Если БонуснаяКарта = Неопределено И Не Запись.БылоСоздание Тогда
				
				ЖурналВыгрузки.Удалить(Запись); 
				
			ИначеЕсли БонуснаяКарта = Неопределено И Запись.БылоСоздание Тогда
				
				Запись.ВидОперации = "УДАЛИТЬ";	
				
			ИначеЕсли Не Запись.БылоСоздание Тогда 
				
				Запись.ВидОперации = "СОЗДАТЬ";	
				Запись.ДатаРегитрации = ТекущаяДата();
				Запись.БонуснаяКарта = БонуснаяКарта;
				Запись.Сумма = Сумма;  
							
			ИначеЕсли Запись.БылоСоздание Тогда
				
				Запись.ВидОперации = "ОБНОВИТЬ";	
				Запись.ДатаРегитрации = ТекущаяДата();
				Запись.БонуснаяКарта = БонуснаяКарта;
				Запись.Сумма = Сумма;
				
			КонецЕсли;	
						
		КонецЦикла;
			
	ИначеЕсли ЗначениеЗаполнено(БонуснаяКарта) И Сумма > 0 Тогда
		
		Запись = ЖурналВыгрузки.Добавить();  
		Запись.ВидОперации = "СОЗДАТЬ";
		Запись.Документ = Документ;
		Запись.ДатаРегитрации = ТекущаяДата();
		Запись.БонуснаяКарта = БонуснаяКарта;
		Запись.Сумма = Сумма;   
		
	КонецЕсли;
	
	ЖурналВыгрузки.Записать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ВыгрузитьИзмененияБонусов(РучнойРежим = Истина) Экспорт
	
	НастройкиИнтеграции = ПолучитьНастройкиИнтеграции();
	
	Если НастройкиИнтеграции = Неопределено Тогда
		
		ЗаписьЖурналаРегистрации("Выгрузка изменений бонусных баллов",
			УровеньЖурналаРегистрации.Предупреждение,
			Метаданные.Подсистемы.пд_ИнтеграцияLegendCity.Имя,,
			"Не заполнены настройки интеграции.");
			
		Возврат;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	
	"ВЫБРАТЬ
	|	БонусныеНачисленияКВыгрузке.ДатаРегитрации КАК ДатаРегитрации,
	|	БонусныеНачисленияКВыгрузке.БонуснаяКарта КАК БонуснаяКарта,
	|	БонусныеНачисленияКВыгрузке.Документ КАК Документ,
	|	БонусныеНачисленияКВыгрузке.Сумма КАК Сумма,
	|	БонусныеНачисленияКВыгрузке.Идентификатор КАК Идентификатор,
	|	БонусныеНачисленияКВыгрузке.Выгружено КАК Выгружено,
	|	БонусныеНачисленияКВыгрузке.ВидОперации КАК ВидОперации
	|ИЗ
	|	РегистрСведений.пд_БонусныеНачисленияКВыгрузке КАК БонусныеНачисленияКВыгрузке
	|ГДЕ
	|	НЕ БонусныеНачисленияКВыгрузке.Выгружено";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ВидОперации = "СОЗДАТЬ" Тогда
			
			СтруктураЗапроса = Новый Структура;
			СтруктураЗапроса.Вставить("date", Формат(УниверсальноеВремя(Выборка.ДатаРегитрации, ЧасовойПояс()), "ДФ=гггг-ММ-ддTЧЧ:мм:ссZ"));
			СтруктураЗапроса.Вставить("cardCode", Число(Выборка.БонуснаяКарта.КодКарты));
			СтруктураЗапроса.Вставить("amount", Выборка.Сумма * 100);
			СтруктураЗапроса.Вставить("description", "Бонусы из 1С");
			
			ДанныеОтвета = ОтправитьНачислениеБонусов(НастройкиИнтеграции, СтруктураЗапроса); 
			
			Если Не ДанныеОтвета = Неопределено 
				И ДанныеОтвета.Свойство("bonusGuid") Тогда
				
				ЖурналВыгрузки = РегистрыСведений.пд_БонусныеНачисленияКВыгрузке.СоздатьНаборЗаписей();
				ЖурналВыгрузки.Отбор.Документ.Установить(Выборка.Документ);
				ЖурналВыгрузки.Отбор.БонуснаяКарта.Установить(Выборка.БонуснаяКарта);
				ЖурналВыгрузки.Прочитать();
				
				ЖурналВыгрузки[0].Идентификатор = ДанныеОтвета.bonusGuid;
               	ЖурналВыгрузки[0].Выгружено = Истина;
				ЖурналВыгрузки[0].БылоСоздание = Истина;
                ЖурналВыгрузки[0].ВидОперации = "";
				
				ЖурналВыгрузки.Записать();
				
			КонецЕсли;
			
		ИначеЕсли Выборка.ВидОперации = "ОБНОВИТЬ" Тогда  
			
			СтруктураЗапроса = Новый Структура;
			СтруктураЗапроса.Вставить("bonusGuid", Выборка.Идентификатор);
			СтруктураЗапроса.Вставить("cardCode", Число(Выборка.БонуснаяКарта.КодКарты));
			СтруктураЗапроса.Вставить("amount", Выборка.Сумма * 100);
				
			ДанныеОтвета = ИзменитьНачислениеБонусов(НастройкиИнтеграции, СтруктураЗапроса, Выборка.Идентификатор);
			
			Если ДанныеОтвета Тогда
				
				ЖурналВыгрузки = РегистрыСведений.пд_БонусныеНачисленияКВыгрузке.СоздатьНаборЗаписей();
				ЖурналВыгрузки.Отбор.Документ.Установить(Выборка.Документ);
				ЖурналВыгрузки.Отбор.БонуснаяКарта.Установить(Выборка.БонуснаяКарта);
				ЖурналВыгрузки.Прочитать();
				
               	ЖурналВыгрузки[0].Выгружено = Истина;
				ЖурналВыгрузки[0].ВидОперации = "";
				
				ЖурналВыгрузки.Записать();				
				
			КонецЕсли;
			
		ИначеЕсли Выборка.ВидОперации = "УДАЛИТЬ" Тогда 
			
			СтруктураЗапроса = Новый Структура;
			СтруктураЗапроса.Вставить("bonusGuid", Выборка.Идентификатор);
			
			ДанныеОтвета = ВыполнитьУдалениеБонусов(НастройкиИнтеграции, СтруктураЗапроса, Выборка.Идентификатор);
			
			Если ДанныеОтвета Тогда
				
				ЖурналВыгрузки = РегистрыСведений.пд_БонусныеНачисленияКВыгрузке.СоздатьНаборЗаписей();
				ЖурналВыгрузки.Отбор.Документ.Установить(Выборка.Документ);
				ЖурналВыгрузки.Отбор.БонуснаяКарта.Установить(Выборка.БонуснаяКарта);
				ЖурналВыгрузки.Прочитать();
				ЖурналВыгрузки.Удалить(ЖурналВыгрузки[0]);
				ЖурналВыгрузки.Записать();
			
			КонецЕсли;
			
		КонецЕсли;
			
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти

#Область РаботаССервисом

Функция ОтправитьНачислениеБонусов(НастройкиИнтеграции, ДанныеЗапроса)
	
	СоединениеHTTP = УстановитьСоединение(НастройкиИнтеграции.АдресСервиса);
	
	Если СоединениеHTTP = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	HTTPЗапрос = Новый HTTPЗапрос(
		"/v4/bonuses",
		ПолучитьЗаголовкиСоединения(НастройкиИнтеграции.КлючAPI)
	);
	
	Если ДанныеЗапроса <> Неопределено Тогда
		
		HTTPЗапрос.УстановитьТелоИзСтроки(
			ФормированиеДанныхЗапроса(ДанныеЗапроса), 
			КодировкаТекста.UTF8,
			ИспользованиеByteOrderMark.НеИспользовать);	
			
	КонецЕсли;
	
	ДанныеОтвета = Неопределено;
	
	Попытка
		
		HTTPОтвет = СоединениеHTTP.ОтправитьДляОбработки(HTTPЗапрос);
		
		Если HTTPОтвет.КодСостояния = 200 Тогда
			
			ДанныеОтвета = ПолучитьДанныеЗапроса(HTTPОтвет);
						
		Иначе
		
			ВызватьИсключение "Ошибка начисления бонусных баллов -> код ошибки: " + Формат(HTTPОтвет.КодСостояния, "ЧГ=0") 
				+ Символы.ПС
				+ "Описание: " + HTTPОтвет.ПолучитьТелоКакСтроку();
							
		КонецЕсли;
		
	Исключение
		
		ВызватьИсключение "Ошибка начисления бонусных баллов -> код ошибки: " + Формат(HTTPОтвет.КодСостояния, "ЧГ=0") 
				+ Символы.ПС
				+ "Описание: " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()); 
				
	КонецПопытки;	

	Возврат ДанныеОтвета;
		
КонецФункции

Функция ИзменитьНачислениеБонусов(НастройкиИнтеграции, ДанныеЗапроса, Идентификатор)
	
	СоединениеHTTP = УстановитьСоединение(НастройкиИнтеграции.АдресСервиса);
	
	Если СоединениеHTTP = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	HTTPЗапрос = Новый HTTPЗапрос(
		"/v4/bonuses/" + Идентификатор,
		ПолучитьЗаголовкиСоединения(НастройкиИнтеграции.КлючAPI)
	);
	
	Если ДанныеЗапроса <> Неопределено Тогда
		
		HTTPЗапрос.УстановитьТелоИзСтроки(
			ФормированиеДанныхЗапроса(ДанныеЗапроса), 
			КодировкаТекста.UTF8,
			ИспользованиеByteOrderMark.НеИспользовать);	
			
	КонецЕсли;
	
	ДанныеОтвета = Ложь;
	
	Попытка
		
		HTTPОтвет = СоединениеHTTP.ОтправитьДляОбработки(HTTPЗапрос);
		
		Если HTTPОтвет.КодСостояния = 200 Тогда
			
			ДанныеОтвета = Истина;
						
		Иначе
		
			ВызватьИсключение "Ошибка изменения бонусных баллов -> код ошибки: " + Формат(HTTPОтвет.КодСостояния, "ЧГ=0") 
				+ Символы.ПС
				+ "Описание: " + HTTPОтвет.ПолучитьТелоКакСтроку();
							
		КонецЕсли;
		
	Исключение
		
		ВызватьИсключение "Ошибка изменения бонусных баллов -> код ошибки: " + Формат(HTTPОтвет.КодСостояния, "ЧГ=0") 
				+ Символы.ПС
				+ "Описание: " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()); 
				
	КонецПопытки;	

	Возврат ДанныеОтвета;
		
КонецФункции

Функция ВыполнитьУдалениеБонусов(НастройкиИнтеграции, ДанныеЗапроса, Идентификатор)

	СоединениеHTTP = УстановитьСоединение(НастройкиИнтеграции.АдресСервиса);
	
	Если СоединениеHTTP = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	HTTPЗапрос = Новый HTTPЗапрос(
		"/v4/bonuses/" + СокрЛП(Идентификатор),
		ПолучитьЗаголовкиСоединения(НастройкиИнтеграции.КлючAPI)
	);
		
	ДанныеОтвета = Ложь;
	
	Попытка
		
		HTTPОтвет = СоединениеHTTP.Удалить(HTTPЗапрос);
		
		Если HTTPОтвет.КодСостояния = 200 Тогда
			
			ДанныеОтвета = Истина;
						
		Иначе
		
			ВызватьИсключение "Ошибка удаления бонусных баллов -> код ошибки: " + Формат(HTTPОтвет.КодСостояния, "ЧГ=0") 
				+ Символы.ПС
				+ "Описание: " + HTTPОтвет.ПолучитьТелоКакСтроку();
							
		КонецЕсли;
		
	Исключение
		
		ВызватьИсключение "Ошибка удаления бонусных баллов -> код ошибки: " + Формат(HTTPОтвет.КодСостояния, "ЧГ=0") 
				+ Символы.ПС
				+ "Описание: " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()); 
				
	КонецПопытки;	

	Возврат ДанныеОтвета;
	
КонецФункции

/////////////////////////////////////////////////////////////////

Функция УстановитьСоединение(АдресAPI)
	
	Попытка
		
		
		Если СтрНайти(АдресAPI, "https") Тогда
			
			HTTPS_Соединение = Новый ЗащищенноеСоединениеOpenSSL;
			
			Результат = Новый HTTPСоединение(
				СтрЗаменить(АдресAPI, "https://", ""), 
				443,,,,
				15,
				HTTPS_Соединение);
				
		Иначе
			
			Результат = Новый HTTPСоединение(
				СтрЗаменить(АдресAPI, "http://", ""), 
				80,,,,
				15);

			
		КонецЕсли;
		
				
				
	Исключение
		
		ЗаписьЖурналаРегистрации(
			"Установка соединение с сервисом LegendCity",
			УровеньЖурналаРегистрации.Информация,
			Метаданные.Подсистемы.пд_ИнтеграцияLegendCity.Имя,,
			"Не удалось установить соединение с сервером. Проверьте настройки авторизации."
			);
			
		Результат = Неопределено;
		
	Конецпопытки;	
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьЗаголовкиСоединения(КлючAPI)
	
	ЗаголовкиHTTP = Новый Соответствие;
	ЗаголовкиHTTP.Вставить("x-api-key", СокрЛП(КлючAPI));
	ЗаголовкиHTTP.Вставить("Content-Type", "application/json; charset=utf-8");
	
	Возврат ЗаголовкиHTTP;
	
КонецФункции	

Функция ПолучитьДанныеЗапроса(ДанныеОтвета)
	
	ЧтениеJSON = Новый ЧтениеJSON;
	
	ЧтениеJSON.УстановитьСтроку(
		ДанныеОтвета.ПолучитьТелоКакСтроку()
	);
	
	Попытка
		
		ДанныеЗапроса = ПрочитатьJSON(ЧтениеJSON);
		ЧтениеJSON.Закрыть();
		
		Возврат ДанныеЗапроса;
		
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции	

Функция ФормированиеДанныхЗапроса(ДанныеЗапроса)
	
	ЗапросJSON = Новый ЗаписьJSON;
	
	ЗапросJSON.УстановитьСтроку();
	
	ЗаписатьJSON(ЗапросJSON, ДанныеЗапроса);
	
	Возврат ЗапросJSON.Закрыть();
		
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьНастройкиИнтеграции() Экспорт
	
	Возврат ХранилищеОбщихНастроек.Загрузить(
		Метаданные.Подсистемы.пд_ИнтеграцияLegendCity.Имя,
		"НастройкиИнтеграции",,
		"1С");
	
КонецФункции
	
#КонецОбласти