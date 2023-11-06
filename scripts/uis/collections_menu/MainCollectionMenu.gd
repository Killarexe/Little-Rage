extends Control
class_name MainCollectionMenu

@onready var animation_player: AnimationPlayer = $SelectButtons/AnimationPlayer
@onready var camera_animation_player: AnimationPlayer = $"../../DefaultLevel/Player/PlayerViewer/AnimationPlayer"

func _ready():
	MusicManager.play_music("collection_main_menu")

func _on_skins_button_pressed():
	set_menu_to(0)

func _on_hats_button_pressed():
	set_menu_to(1)

func _on_particles_button_pressed():
	set_menu_to(2)

func set_menu_to(menu: int):
	animation_player.play_backwards("enter")
	await animation_player.animation_finished
	visible = false
	MusicManager.play_music("collection_cosmetic_selection", MusicManager.get_playback_position())
	match menu:
		0:
			camera_animation_player.play("zoom_skin")
			$"../SkinsMenu".visible = true
		1:
			camera_animation_player.play("zoom_hat")
			$"../HatsMenu".visible = true
		2:
			camera_animation_player.play("zoom_particles")
			$"../ParticlesMenu".visible = true

func _on_back_button_pressed():
	animation_player.play_backwards("enter")
	await animation_player.animation_finished
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")

func _on_achievements_button_pressed():
	animation_player.play_backwards("enter")
	await animation_player.animation_finished
	SceneManager.change_scene("res://scenes/uis/AchievementMenu.tscn")