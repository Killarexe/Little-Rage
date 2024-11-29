extends Control
class_name LevelEditorMenu

@export var level_editor: LevelEditor
@export var brush: BrushComponent
@export var level_settings_animation_player: AnimationPlayer

@export var quit_button: Button
@export var save_button: Button
@export var load_button: Button
@export var settings_button: Button
@export var file_dialog: FileDialog
@export var animation_player: AnimationPlayer

func _ready() -> void:
	file_dialog.visible = false
	file_dialog.canceled.connect(func(): animation_player.play_backwards("Menu/show_load_dialog"))
	file_dialog.file_selected.connect(on_load_file_selected)
	save_button.pressed.connect(on_save_button_pressed)
	load_button.pressed.connect(on_load_button_pressed)
	settings_button.pressed.connect(on_settings_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)

func on_load_file_selected(path: String) -> void:
	animation_player.play_backwards("Menu/show_load_dialog")
	await animation_player.animation_finished
	level_editor.load_level(path)

func on_load_button_pressed() -> void:
	animation_player.play("Menu/show_load_dialog")

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
