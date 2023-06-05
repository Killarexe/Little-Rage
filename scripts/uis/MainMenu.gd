extends Control

func _ready():
	MusicManager.play_music("main_menu")
	$Camera2D/AnimationPlayer.play("scroll")
	$CanvasLayer/Logo/AnimationPlayer.play("logo_move")

func _on_editor_button_pressed():
	SceneManager.change_scene("res://scenes/uis/LevelEditor.tscn")

func _on_settings_button_pressed():
	SceneManager.change_scene("res://scenes/uis/SettingsMenu.tscn")

func _on_play_button_pressed():
	SceneManager.change_scene("res://scenes/uis/LevelSelector.tscn")
