extends Node
class_name JumpingTileComponent

@export var interative_tile: InteractiveTile

var is_player_entered: bool = false

func _ready() -> void:
	interative_tile.on_body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D) -> void:
	if body is PlayerComponent && !is_player_entered:
		is_player_entered = true
		body.controller.JUMP_FORCE *= 1.25
		await body.controller.on_jump
		body.controller.JUMP_FORCE /= 1.25
		is_player_entered = false
