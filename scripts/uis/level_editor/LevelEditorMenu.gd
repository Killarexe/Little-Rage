extends Control
class_name LevelEditorMenu

@export var level_editor: LevelEditor
@export var brush: BrushComponent
@export var level_settings_animation_player: AnimationPlayer

@export var quit_button: Button
@export var save_button: Button
@export var load_button: Button
@export var settings_button: Button
@export var animation_player: AnimationPlayer

func _ready() -> void:
	save_button.pressed.connect(on_save_button_pressed)
	settings_button.pressed.connect(on_settings_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)

func on_settings_button_pressed() -> void:
	if level_editor.level_settings.visible:
		brush.enable = true
		level_settings_animation_player.play_backwards("LevelSettingsMenu/show")
	else:
		brush.enable = false
		level_settings_animation_player.play("LevelSettingsMenu/show")

func on_save_button_pressed() -> void:
	level_editor.save_level()

func on_quit_button_pressed() -> void:
	animation_player.play_backwards("Menu/show")
	await animation_player.animation_finished
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")
