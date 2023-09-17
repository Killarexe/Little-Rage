extends CanvasLayer

func _ready():
	pause()

func pause():
	visible = !visible
	get_tree().paused = visible

func _on_back_to_game_button_pressed():
	pause()

func _on_quit_button_pressed():
	get_tree().paused = false
	SceneManager.change_scene("res://scenes/uis/LevelSelector.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("pause") && Global.can_pause:
		pause()

func _on_replay_button_pressed():
	SceneManager.change_packed(LevelManager.get_current_level().scene)
