extends Control

var is_paused = false : set = set_paused

func _ready():
	set_paused(false)

func _unhandled_input(event):
	if(event.is_action_pressed("pause") && Global.ableToPause):
		self.is_paused = !is_paused

func set_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_QuitButton_pressed():
	set_paused(false)
	SceneTransition.change_scene_to_file("res://scenes/ui/MainMenu.tscn")

func _on_ResumeButton_pressed():
	set_paused(false)
