extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func change_scene_to_file(target: String) -> void:
	animation_player.play("dissolve")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(target)
	animation_player.play_backwards("dissolve")
