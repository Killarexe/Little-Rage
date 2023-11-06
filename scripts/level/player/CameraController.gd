extends Camera2D

@export var player: PlayerMovement

func _ready():
	enabled = player.camera_enabled

func _process(delta: float):
	if player.camera_enabled:
		offset.x = lerpf(offset.x, player.velocity.x / 3, delta)
