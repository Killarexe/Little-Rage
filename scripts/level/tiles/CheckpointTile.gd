extends InteractiveTile
class_name CheckpointTile

@export_category("Checkpoint components")
@export var tile_off_texture: Sprite2D
@export var checkpoint_particle: PackedScene

func on_body_entered(body: Node2D) -> void:
	if body is PlayerComponent && tile_off_texture.visible:
		tile_off_texture.visible = false
		var spawn_point: Vector2 = global_position - Vector2(0, 32)
		body.get_node("DeathComponent").spawn_point = spawn_point
		Game.instanceNodeAtPos(checkpoint_particle, body.get_parent(), spawn_point)
