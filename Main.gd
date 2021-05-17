extends Control

onready var select_lang = $Content/Language/Select

func _ready():
	if not Boot.inited:
		yield(Boot, "inited_updated")
		
	for locale in TranslationServer.get_loaded_locales():
		select_lang.add_item(locale.to_upper())
		
	select_lang.connect("item_selected", self, "on_select_lang")
	
func on_select_lang(idx):
	TranslationServer.set_locale(TranslationServer.get_loaded_locales()[idx])
