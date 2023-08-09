extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect

func get_animation() -> String:
	var transition: String = animation_player.get_animation_list()[
		randi_range(0, animation_player.get_animation_list().size() - 1)
	]
	if transition == "RESET":
		return get_animation()
	return transition

func change_scene(path: String) -> void:
	color_rect.global_position = Vector2(0, 0)
	var transition: String = get_animation()
	animation_player.play(transition)
	await animation_player.animation_finished
	get_tree().change_scene_to_file(path)
	animation_player.play_backwards(transition)

func change_packed(packed: PackedScene) -> void:
	color_rect.global_position = Vector2(0, 0)
	var transition: String = get_animation()
	animation_player.play(transition)
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(packed)
	animation_player.play_backwards(transition)
