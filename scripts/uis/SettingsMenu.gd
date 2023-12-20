extends Control

@onready var language_menu: OptionButton = $CanvasLayer/VBoxContainer/Language/MenuButton

func _ready():
	MusicManager.play_music("settings_menu")
	$Camera2D/AnimationPlayer.play("camera_scroll")
	$CanvasLayer/VBoxContainer/MusicVolume/Slider.set_value_no_signal(MusicManager.music_volume)
	$CanvasLayer/VBoxContainer/SoundEffectVolume/Slider.set_value_no_signal(MusicManager.sound_effect_volume)
	$CanvasLayer/VBoxContainer/WindowSize/OptionButton.select(WindowManager.window_size)
	$CanvasLayer/SoundTrackButton.visible = randf() <= 0.05 || (Input.is_action_pressed("pause") && Input.is_action_pressed("down"))
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

func _on_sfx_slider_value_changed(value: int):
	MusicManager.sound_effect_volume = value
	SaveManager.save()

func _on_volume_slider_value_changed(value: int):
	MusicManager.set_music_volume(value)

func _on_menu_button_item_selected(index: int):
	TranslationServer.set_locale(TranslationServer.get_loaded_locales()[index])
	SaveManager.save()

func _on_reset_buttton_pressed():
	$ConfirmationDialog.popup_centered()

func _on_confirmation_dialog_confirmed():
	SaveManager.reset_save()
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")

func _on_sound_track_button_pressed():
	PlayerSkinManager.unlock_skin("rgb", true)
	SceneManager.change_scene("res://scenes/uis/SoundTrackMenu.tscn")

func _on_option_button_item_selected(index: int):
	WindowManager.window_size = index
	WindowManager.update_window(index)
	SaveManager.save()
