extends Camera2D

@export var player: PlayerMovement

func _process(delta: float):
	if player.controllable:
		offset.x = lerpf(offset.x, player.velocity.x / 3, delta)
