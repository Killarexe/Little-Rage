extends Control

@onready var player_skin: PlayerSkinSprite = $"../../DefaultLevel/Player/Skin"
@onready var main_menu: MainCollectionMenu = $"../MainMenu"
@onready var camera_animation_player: AnimationPlayer = $"../../DefaultLevel/Player/Camera2D/AnimationPlayer"

func _on_back_button_pressed():
	visible = false
	camera_animation_player.play_backwards("zoom_skin")
	main_menu.visible = true
	await camera_animation_player.animation_finished
	MusicManager.play_music("collection_main_menu", MusicManager.get_playback_position())
	main_menu.animation_player.play("enter")
