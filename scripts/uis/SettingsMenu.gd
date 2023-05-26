extends Control

func _ready():
	$Camera2D/AnimationPlayer.play("camera_scroll")

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/uis/MainMenu.tscn")
