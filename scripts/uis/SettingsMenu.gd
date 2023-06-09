extends Control

@onready var language_menu: OptionButton = $CanvasLayer/VBoxContainer/Language/MenuButton

func _ready():
	$Camera2D/AnimationPlayer.play("camera_scroll")
	$CanvasLayer/VBoxContainer/MusicVolume/Slider.set_value_no_signal(MusicManager.music_volume)
	$CanvasLayer/VBoxContainer/SoundEffectVolume/Slider.set_value_no_signal(MusicManager.sound_effect_volume)
	for i in TranslationServer.get_loaded_locales().size():
		var language: String = TranslationServer.get_loaded_locales()[i]
		language_menu.add_icon_item(
			load("res://assets/textures/ui/flags/" + language + ".png"),
			language
		)
		if language == TranslationServer.get_locale():
			language_menu.select(i)

func _on_back_button_pressed():
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")

func _on_sfx_slider_value_changed(value):
	MusicManager.sound_effect_volume = value
	Global.save_game()

func _on_volume_slider_value_changed(value):
	MusicManager.set_music_volume(value)

func _on_menu_button_item_selected(index):
	TranslationServer.set_locale(TranslationServer.get_loaded_locales()[index])
	Global.save_game()
