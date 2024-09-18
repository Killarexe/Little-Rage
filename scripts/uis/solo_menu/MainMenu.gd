extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var default_levels: DefaultLevelSelectionMenu = $"../DefaultLevelsSelectionMenu"
@onready var custom_levels: DefaultLevelSelectionMenu = $"../CustomLevelsSelectionMenu"
@onready var camera_animation_player: AnimationPlayer = $"../../DefaultLevel/PlayerDummy/PlayerCamera/AnimationPlayer"

func _ready() -> void:
	animation_player.play("enter")
	MusicManager.play_music("level_selection_menu")

func _on_default_levels_button_pressed() -> void:
	select_menu(0)

func _on_custom_levels_button_pressed() -> void:
	select_menu(1)

func _on_weekly_level_button_pressed() -> void:
	select_menu(2)

func select_menu(menu: int) -> void:
	animation_player.play("out")
	await animation_player.animation_finished
	camera_animation_player.play("zoom")
	await camera_animation_player.animation_finished
	visible = false
	match menu:
		0:
			default_levels.visible = true
			default_levels.animation_player.play("enter")
		1:
			custom_levels.visible =  true
			custom_levels.animation_player.play("enter")
		2:
			pass

func _on_back_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")
