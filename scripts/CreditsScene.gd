extends Node2D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func end():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")
