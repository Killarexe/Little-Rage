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
	get_tree().change_scene_to_file("res://scenes/uis/MainMenu.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pause()
