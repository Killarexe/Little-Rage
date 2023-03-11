extends Node2D

func _ready():
	var player = load("res://scenes/prefabs/Player.tscn")
	Global.instanceNodeAtPos(player, self, Vector2(0, 0))
	$Clouds/AnimationPlayer.play("clouds")
	if(name == "TitleLevel"):
		get_node("Player").set_max_y(2048)
		get_node("Player").global_position.x = 205
		get_node("Player").global_position.y = 850
		get_node("Player").enable_camera = false
		get_node("Player").get_node("Camera2D").queue_free()
		Global.unablePause()

func get_tile_data(name: String, tile_pos: Vector2) -> Variant:
	var data: TileData = $Map.get_cell_tile_data(2, tile_pos)
	if data != null:
		return data.get_custom_data(name)
	return null

func get_tile_id(cell_pos: Vector2i) -> Vector2i:
	return $Map.get_cell_atlas_coords(2, cell_pos)

func replace_tile_by(old_tile_id: Vector2i, new_tile_id: Vector2i):
	for cell_pos in $Map.get_used_cells_by_id(2, -1, old_tile_id):
		$Map.set_cell(2, cell_pos, 1, new_tile_id, 0)
