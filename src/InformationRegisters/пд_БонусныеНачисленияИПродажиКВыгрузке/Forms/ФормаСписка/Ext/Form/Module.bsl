﻿
&НаКлиенте
Процедура ВыполнитьВыгрузкуБонусныхБалло(Команда)

	ИдентифкаторЗадания = ЗапускФоновогоЗадания();
	
	ОбработкаЗавершения = Новый ОписаниеОповещения("ВыполнениеДлительнойОперацииЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("ОбщаяФорма.ДлительнаяОперация", Новый Структура("ТекстСообщения, ИдентификаторЗадания, ВыводитьОкноОжидания",
		"Выполняется выгрузка бонусных баллов...",
			ИдентифкаторЗадания,
			Истина),
		ЭтотОбъект,
		Новый УникальныйИдентификатор,,,
		ОбработкаЗавершения
	);

КонецПроцедуры

&НаСервере
Функция ЗапускФоновогоЗадания()
	
	ФЗ = ФоновыеЗадания.Выполнить("пд_ОбменСLegendCity.ВыгрузитьИзмененияПродажИБонусовРегламентноеЗадание", 
		Неопределено, 
		Новый УникальныйИдентификатор, 
		"Выгрузка продаж и бонусных баллов (api.legendcity.ru)"
	);
		
	Возврат ФЗ.УникальныйИдентификатор;
	
КонецФункции

&НаКлиенте
Процедура ВыполнениеДлительнойОперацииЗавершение(Результат, ДопПараметры) Экспорт
	
	Если Результат.Статус = "Выполнено" Тогда
		
		ПоказатьПредупреждение(, "Обмен завершен.");
		
		Элементы.Список.Обновить();
		
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("В результате выполнения операции произошла ошибка"
			+ Символы.ПС
			+ "Описане: " + Результат.КраткоеПредставлениеОшибки);
	КонецЕсли;
	
КонецПроцедуры
