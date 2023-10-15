extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: ColorRect = $Texture

func prepare():
	texture_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	texture_rect.global_position = Vector2(0, 0)
	texture_rect.modulate = Color(1.0, 1.0, 1.0, 1.0)

func end():
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_rect.modulate = Color(1.0, 1.0, 1.0, 0.0)

func change_scene(path: String) -> void:
	prepare()
	animation_player.play("Transitions/scroll")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(path)
	end()

func change_packed(packed: PackedScene) -> void:
	prepare()
	get_tree().change_scene_to_packed(packed)
	animation_player.play("Transitions/scroll")
	await animation_player.animation_finished
	end()
