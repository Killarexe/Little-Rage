extends Node
class_name AccelerationTileComponent

@export var interative_tile: InteractiveTile

var player: PlayerComponent = null
var original_acceleration: float = -1
var original_max_speed: float = -1

func _ready() -> void:
	interative_tile.on_body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D):
	if body is PlayerComponent:
		if player == null:
			player = body
			original_acceleration = player.controller.ACCEL
			original_max_speed = player.controller.MAX_SPEED
			player.controller.ACCEL *= 3
			player.controller.MAX_SPEED *= 3

func _process(delta: float) -> void:
	if player != null:
		player.controller.ACCEL = lerpf(player.controller.ACCEL, original_acceleration, delta * 2)
		player.controller.MAX_SPEED = lerpf(player.controller.MAX_SPEED, original_max_speed, delta * 2)
		if original_acceleration + 0.01 >= player.controller.ACCEL && original_max_speed + 0.01 >= player.controller.MAX_SPEED:
			player.controller.ACCEL = original_acceleration
			player.controller.MAX_SPEED = original_max_speed
			player = null
