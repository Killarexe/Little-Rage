@tool
extends Node
class_name ColorTileComponent

@export var use_polygone_shape: bool = false:
	set(value):
		use_polygone_shape = value
		notify_property_list_changed()
@export var disable_tile_collision: bool = false:
	set(value):
		disable_tile_collision = value
		notify_property_list_changed()
@export var disable_area_collision: bool = false:
	set(value):
		disable_area_collision = value
		notify_property_list_changed()
@export var off_texture: Sprite2D

var tile_collision_shape
var area_collision_shape: CollisionShape2D

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	if disable_tile_collision:
		var hint: String = "CollisionShape2D"
		if use_polygone_shape:
			hint = "CollisionPolygon2D"
		properties.append({
			"name": "tile_collision_shape",
			"type": TYPE_OBJECT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NODE_TYPE,
			"hint_string": hint
		})
	if disable_area_collision:
		properties.append({
			"name": "area_collision_shape",
			"type": TYPE_OBJECT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NODE_TYPE,
			"hint_string": "CollisionShape2D"
		})
	return properties

func _ready() -> void:
	add_to_group("ColorTiles")

func switch_texture() -> void:
	off_texture.visible = !off_texture.visible
	if disable_tile_collision:
		tile_collision_shape.disabled = off_texture.visible
	if disable_area_collision:
		area_collision_shape.disabled = off_texture.visible
