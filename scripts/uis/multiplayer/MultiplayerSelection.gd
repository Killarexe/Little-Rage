extends Control

func _ready():
	MusicManager.play_music("multiplayer_lobby")
	$Camera2D/AnimationPlayer.play("camera_scroll")

func _on_local_pressed():
	pass # Replace with function body.

func _on_online_pressed():
	pass # Replace with function body.

func _on_back_pressed():
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")
