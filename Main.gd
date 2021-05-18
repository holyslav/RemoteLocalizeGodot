extends Control

onready var select_lang = $Content/Language/Select
onready var content = $Content
onready var loading = $Loading
onready var tw = $Tween

func _ready():
	content.modulate.a = 0 #установка прозрачности контейнера
	
	while not Boot.inited: #ожидание пока локали не прогрузятся
		tw.interpolate_property(loading, "rect_rotation", 0, 360, 2, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT) #вращение логотипа загрузки
		tw.start()
		yield(tw, "tween_all_completed") #ожидание окончания анимации
		
	show_page()
	
func show_page():
	tw.interpolate_property(loading, "modulate:a", 1, 0, 1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT) #скрытие через прозрачность
	tw.interpolate_property(content, "modulate:a", 0, 1, 1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT) #показ
	tw.start()
	
	for locale in TranslationServer.get_loaded_locales(): #перебор загруженных локалей и добавление в опшинал
		select_lang.add_item(locale.to_upper())
	
	select_lang.select(TranslationServer.get_loaded_locales().find(TranslationServer.get_locale())) #установка текущей локали
	
	select_lang.connect("item_selected", self, "on_select_lang")
	
	
func on_select_lang(idx):
	TranslationServer.set_locale(TranslationServer.get_loaded_locales()[idx]) #установка локали исходя из выбранного итема
