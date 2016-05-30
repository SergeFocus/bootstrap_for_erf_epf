﻿
Перем мНастройки;

Функция ПрочитатьНастройкиИзФайла(Знач ФайлНастроек) Экспорт
	
	мНастройки = Новый Структура;
	
	Чтение = Новый ЧтениеXML();
	Чтение.ОткрытьФайл(ФайлНастроек);
	Попытка
		Чтение.ПерейтиКСодержимому();
		Если Чтение.ЛокальноеИмя <> "gitsync-options" Тогда
			ВызватьИсключение "Неверная структура файла настроек";
		КонецЕсли;
		
		Чтение.Прочитать();
		ПрочитатьГлобальныеНастройки(Чтение);
		ПрочитатьНастройкиРепозитариев(Чтение);
		
	Исключение
		Чтение.Закрыть();
		ВызватьИсключение;
	КонецПопытки;
	
	Чтение.Закрыть();
	
	Возврат мНастройки;
	
КонецФункции

Процедура ПрочитатьГлобальныеНастройки(Знач Чтение)
	Чтение.Прочитать();
	
	Пока Не (Чтение.ТипУзла = ТипУзлаXML.КонецЭлемента и Чтение.ЛокальноеИмя = "global") Цикл
		КлючИЗначение = ПрочитатьОпцию(Чтение);
		
		Если КлючИЗначение.Ключ = "email-domain" Тогда
			Ключ = "ДоменПочтыДляGit";
		ИначеЕсли КлючИЗначение.Ключ = "v8-version" Тогда
			Ключ = "ПутьКПлатформе83";
		ИначеЕсли КлючИЗначение.Ключ = "git-executable" Тогда
			Ключ = "ПутьGit";
		Иначе
			ВызватьИсключение НекорректнаяСтруктураНастроек();
		КонецЕсли;
		
		мНастройки.Вставить(Ключ, КлючИЗначение.Значение);
		
	КонецЦикла;
	
	Чтение.Прочитать();
	
КонецПроцедуры

Процедура ПрочитатьНастройкиРепозитариев(Чтение)
	мНастройки.Вставить("Репозитарии", Новый Массив);
	
	Если Чтение.ЛокальноеИмя <> "repositories" Тогда
		ВызватьИсключение НекорректнаяСтруктураНастроек();
	КонецЕсли;
	
	Чтение.Прочитать();
	
	Пока Не (Чтение.ТипУзла = ТипУзлаXML.КонецЭлемента и Чтение.ЛокальноеИмя = "repositories") Цикл
		ПрочитатьНастройкиРепозитария(Чтение);
	КонецЦикла;
	
	Чтение.Прочитать();
	
КонецПроцедуры

Процедура ПрочитатьНастройкиРепозитария(Чтение)
	
	Репо = Новый Структура;
	Репо.Вставить("Имя", Чтение.ЗначениеАтрибута("name"));
	
	Чтение.Прочитать();
	
	мНастройки.Репозитарии.Добавить(Репо);
	
	Пока Не (Чтение.ТипУзла = ТипУзлаXML.КонецЭлемента и Чтение.ЛокальноеИмя = "repo") Цикл
		
		КлючИЗначение = ПрочитатьОпцию(Чтение);
		
		Если КлючИЗначение.Ключ = "git-local-path" Тогда
			Ключ = "КаталогВыгрузки";
		ИначеЕсли КлючИЗначение.Ключ = "git-remote" Тогда
			Ключ = "GitURL";
		ИначеЕсли КлючИЗначение.Ключ = "v8-storage-dir" Тогда
			Ключ = "КаталогХранилища1С";
		ИначеЕсли КлючИЗначение.Ключ = "email-domain" Тогда
			Ключ = "ДоменПочтыДляGit";
		ИначеЕсли КлючИЗначение.Ключ = "v8-version" Тогда
			Ключ = "ПутьКПлатформе83";
		ИначеЕсли КлючИЗначение.Ключ = "git-executable" Тогда
			Ключ = "ПутьGit";
		Иначе
			ВызватьИсключение НекорректнаяСтруктураНастроек();
		КонецЕсли;
		
		Если ПустаяСтрока(КлючИЗначение.Значение) и мНастройки.Свойство(Ключ) Тогда
			КлючИЗначение.Значение = мНастройки[Ключ];
		КонецЕсли;
		
		Репо.Вставить(Ключ, КлючИЗначение.Значение);
		
	КонецЦикла;
	
	Чтение.Прочитать();
КонецПроцедуры

Функция ПрочитатьОпцию(Знач Чтение)
	
	Перем Ключ;
	Перем Значение;
	
	Ключ = Чтение.ЛокальноеИмя;
	
	Чтение.Прочитать();
	Если Чтение.ТипУзла = ТипУзлаXML.Текст Тогда
		Значение = Чтение.Значение;
		Чтение.Прочитать();
	ИначеЕсли Чтение.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
		Значение = "";
	Иначе
		ВызватьИсключение НекорректнаяСтруктураНастроек();
	КонецЕсли;
	
	Чтение.Прочитать();
	
	Возврат Новый Структура("Ключ,Значение", Ключ, Значение);
	
КонецФункции

Функция НекорректнаяСтруктураНастроек()
	Возврат "Некорректная структура файла настроек";
КонецФункции
