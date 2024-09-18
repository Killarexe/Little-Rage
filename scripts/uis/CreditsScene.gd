extends Node2D

func _ready() -> void:
	MusicManager.stop()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("pause"):
			end()

func end() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")

func _on_skip_button_pressed() -> void:
	end()
