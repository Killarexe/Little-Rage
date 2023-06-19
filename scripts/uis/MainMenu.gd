extends Control

func _ready():
	get_tree().paused = false
	DiscordRPCManager.update_rpc("In Main Menu", "basicicon", "In Main Menu")
	MusicManager.play_music("main_menu")
	$Camera2D/AnimationPlayer.play("scroll")
	$CanvasLayer/Logo/AnimationPlayer.play("logo_move")

func _on_editor_button_pressed():
	SceneManager.change_scene("res://scenes/uis/LevelEditor.tscn")

func _on_settings_button_pressed():
	SceneManager.change_scene("res://scenes/uis/SettingsMenu.tscn")

func _on_play_button_pressed():
	SceneManager.change_scene("res://scenes/uis/LevelSelector.tscn")

func _on_multiplayer_button_pressed():
	SceneManager.change_scene("res://scenes/uis/MultiplayerSelection.tscn")

func _on_shop_button_pressed():
	SceneManager.change_scene("res://scenes/uis/ShopMenu.tscn")

func _on_quit_button_pressed():
	Global.save_game()
	get_tree().quit()

