extends Control
class_name DefaultLevelSelectionMenu

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var main_menu: Control = $"../SoloMainMenu"
@onready var level_list: LevelList = $LevelList
@onready var camera_animation_player: AnimationPlayer = $"../../DefaultLevel/PlayerDummy/PlayerCamera/AnimationPlayer"

func _on_play_button_pressed():
	if level_list.levels.is_empty():
		return
	animation_player.play_backwards("enter")
	await animation_player.animation_finished
	camera_animation_player.play("out_zoomed")
	await camera_animation_player.animation_finished
	var selected_level: Level = level_list.get_level_from_selection()
	LevelManager.current_level = selected_level.id
	SceneManager.change_packed(selected_level.scene, 1, false, 1, true)

func _on_back_button_pressed():
	animation_player.play_backwards("enter")
	await animation_player.animation_finished
	visible = false
	camera_animation_player.play_backwards("zoom")
	await camera_animation_player.animation_finished
	main_menu.visible = true
	main_menu.animation_player.play_backwards("out")
