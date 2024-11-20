extends Control
class_name LevelEditorMenu

@export var quit_button: Button
@export var save_button: Button
@export var load_button: Button
@export var settings_button: Button
@export var animation_player: AnimationPlayer

func _ready() -> void:
	quit_button.pressed.connect(on_quit_button_pressed)

func on_quit_button_pressed() -> void:
	animation_player.play_backwards("Menu/show")
	await animation_player.animation_finished
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")
