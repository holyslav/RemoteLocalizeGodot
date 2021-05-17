extends Node

var http = null

const git_path = "https://raw.githubusercontent.com/holyslav/RemoteLocalizeGodot_lang_files/main/%s.json"

var inited = false

signal inited_updated

func _ready():
	http = HTTPRequest.new()
	add_child(http)
	
	http.request(git_path % "locales")
	var locales_raw = yield(http, "request_completed")
	var locales_body = locales_raw[3]
	if locales_body:
		
		var locales_json = JSON.parse(locales_body.get_string_from_utf8()).result
		
		for locale in locales_json.locales:
			
			http.request(git_path % locale)
			var locale_raw = yield(http, "request_completed")
			var locale_body = locale_raw[3]
			var locale_json = JSON.parse(locale_body.get_string_from_utf8()).result

			var trans = Translation.new()
			trans.set_locale(locale)
			for word in locale_json:
				trans.add_message(word, locale_json[word])

			TranslationServer.add_translation(trans)
			
	var system_locale = OS.get_locale().split('_')[0]
	TranslationServer.set_locale(system_locale)
	
	inited = true
	emit_signal("inited_updated")
