extends Node

var http = null

const git_path = "https://raw.githubusercontent.com/holyslav/RemoteLocalizeGodot_lang_files/main/%s.json" #путь к репозиторию где лежат ваши локали

var inited = false

func get_json(filename:String): #Функция запроса к http серверу для получения содержимого файла
	http.request(git_path % filename) #делаем реквест
	var json_req = yield(http, "request_completed")  #ждём ответ
	var json_body = json_req[3] #вытаскиваем боди
	if json_body:
		return JSON.parse(json_body.get_string_from_utf8()).result #парсим боди в жсон и отдаём
	return null

func _ready():
	http = HTTPRequest.new()
	add_child(http)
	
	var locales_obj = yield(get_json("locales"), "completed") #получаем список локалей
	if locales_obj:
		for locale in locales_obj.locales:
			 #запрашиваем каждую локаль
			var locale_json = yield(get_json(locale), "completed")
			if locale_json:
				var trans = Translation.new() #создаём локаль для сервера переводов годо
				trans.set_locale(locale) #установка названия локали
				for word in locale_json: #перебор каждого слова и добавление в локаль при желании здесь можно сделать какую-то фильтрацию/модификацию переводов
					trans.add_message(word, locale_json[word])
				TranslationServer.add_translation(trans)
			
	var system_locale = OS.get_locale().split('_')[0]
	TranslationServer.set_locale(system_locale)
	
	inited = true
