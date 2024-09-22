extends Node
class_name ColorCollisionTile

@export var body: CollisionObject2D
@export var inverse_collision: bool = false

var collision_layer: int = 0
var collision_mask: int = 0

func _ready() -> void:
	add_to_group("ColorTiles")
	if !body.is_node_ready():
		await body.ready
	save_collision_settings()
	if inverse_collision:
		body.collision_layer = 0
		body.collision_mask = 0

func save_collision_settings() -> void:
	collision_layer = body.collision_layer
	collision_mask = body.collision_mask

func switch_texture() -> void:
	if body.collision_layer != 0:
		save_collision_settings()
		body.collision_layer = 0
		body.collision_mask = 0
	else:
		body.collision_layer = collision_layer
		body.collision_mask = collision_mask
