extends Control

func _ready():
	$Camera2D/AnimationPlayer.play("camera_scroll")
	$CanvasLayer/VBoxContainer/MusicVolume/Slider.set_value_no_signal(MusicManager.music_volume)
	$CanvasLayer/VBoxContainer/SoundEffectVolume/Slider.set_value_no_signal(MusicManager.sound_effect_volume)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/uis/MainMenu.tscn")

func _on_sfx_slider_value_changed(value):
	MusicManager.sound_effect_volume = value
	Global.save_game()

func _on_volume_slider_value_changed(value):
	MusicManager.set_music_volume(value)
