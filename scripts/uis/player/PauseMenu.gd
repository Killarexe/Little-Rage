extends CanvasLayer

func _ready() -> void:
	pause()

func pause(change_mouse: bool = false) -> void:
	visible = !visible
	if change_mouse:
		if visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().paused = visible

func _on_back_to_game_button_pressed() -> void:
	pause(!LevelManager.current_level.is_empty())

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	SceneManager.change_scene("res://scenes/uis/SoloMenu.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") && Game.can_pause:
		pause(!LevelManager.current_level.is_empty())

func _on_replay_button_pressed() -> void:
	SceneManager.change_packed(LevelManager.get_current_level().scene)
