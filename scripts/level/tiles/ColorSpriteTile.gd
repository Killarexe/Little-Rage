extends Node
class_name ColorSpriteTile

@export var on_red_texture: Sprite2D
@export var on_blue_texture: Sprite2D

var inverse_disable_collision: bool = false

func _ready() -> void:
	add_to_group("ColorTiles")
	if !on_red_texture.is_node_ready():
		await on_red_texture.ready
	if !on_blue_texture.is_node_ready():
		await on_blue_texture.ready
	on_red_texture.visible = false
	on_blue_texture.visible = true

func switch_texture() -> void:
	on_red_texture.visible = !on_red_texture.visible
	on_blue_texture.visible = !on_blue_texture.visible
