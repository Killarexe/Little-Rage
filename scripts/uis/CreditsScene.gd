extends Node2D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _unhandled_key_input(event: InputEvent):
	if event is InputEventKey:
		if event.is_action_pressed("pause"):
			end()

func end():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")

func _on_skip_button_pressed():
	end()
