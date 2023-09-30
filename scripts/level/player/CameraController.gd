extends Camera2D

@export var player: PlayerMovement

func _process(delta: float):
	offset.x = lerpf(offset.x, player.velocity.x / 3, delta)
