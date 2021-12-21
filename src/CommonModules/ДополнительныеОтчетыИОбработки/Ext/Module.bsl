﻿
#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Регламентные задания

&Перед("ВыполнитьОбработкуПоРегламентномуЗаданию")
Процедура пд_ВыполнитьОбработкуПоРегламентномуЗаданию(ВнешняяОбработка, ИдентификаторКоманды)
	
	Если СтрНайти(ИдентификаторКоманды, "LegendCity") = 0 Тогда
		Возврат;	
	КонецЕсли;
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ЗапускДополнительныхОбработок);
	
	// Запись журнала регистрации
	ЗаписатьИнформацию(ВнешняяОбработка, 
	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Команда %1: Запуск.'"), ИдентификаторКоманды));
	
	// Выполнение команды
	Попытка
		
		Если СтрНайти(ИдентификаторКоманды, "LegendCity_ВыгрузитьИзмененияБонусов") <> 0 Тогда
			пд_ОбменСLegendCity.ВыгрузитьИзмененияПродажИБонусовРегламентноеЗадание();
		КонецЕсли;		
		
	Исключение
		ЗаписатьОшибку(
		ВнешняяОбработка,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Команда %1: Ошибка выполнения:
		|%2'"),
		ИдентификаторКоманды, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
	КонецПопытки;
	
	// Запись журнала регистрации
	ЗаписатьИнформацию(ВнешняяОбработка, 
	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Команда %1: Завершение.'"), ИдентификаторКоманды));
	
КонецПроцедуры

#КонецОбласти