extends Control

@onready var main_menu: MainCollectionMenu = $"../MainMenu"
@onready var camera_animation_player: AnimationPlayer = $"../../DefaultLevel/PlayerDummy/PlayerViewer/AnimationPlayer"

func _on_back_button_pressed() -> void:
	visible = false
	camera_animation_player.play_backwards("zoom_skin")
	main_menu.visible = true
	await camera_animation_player.animation_finished
	main_menu.animation_player.play("enter")
