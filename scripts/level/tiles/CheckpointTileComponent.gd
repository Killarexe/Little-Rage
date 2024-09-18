extends Node
class_name CheckpointTileComponent

@export_category("Checkpoint components")
@export var interactive_tile: InteractiveTile
@export var tile_off_texture: Sprite2D
@export var checkpoint_particle: PackedScene

func _ready() -> void:
	add_to_group("CheckpointTiles")
	interactive_tile.on_body_entered.connect(_on_checkpoint_tile_on_body_entered)

func switch_off() -> void:
	tile_off_texture.visible = true

func _on_checkpoint_tile_on_body_entered(body: Node2D) -> void:
	if body is PlayerComponent && tile_off_texture.visible:
		get_tree().call_group("CheckpointTiles", "switch_off")
		tile_off_texture.visible = false
		var spawn_point: Vector2 = interactive_tile.global_position - Vector2(0, 32)
		body.get_node("DeathComponent").spawn_point = spawn_point
		Game.instanceNodeAtPos(checkpoint_particle, body.get_parent(), spawn_point + Vector2(0, 16))
