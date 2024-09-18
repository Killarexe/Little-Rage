extends Camera2D
class_name PlayerCamera

@export var player: PlayerComponent

func _process(delta: float) -> void:
	offset.x = lerpf(offset.x, player.velocity.x / 3, delta)
