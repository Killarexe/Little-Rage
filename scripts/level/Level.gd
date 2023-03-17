extends Node2D

func _ready():
	var playerNode = Global.instanceNodeAtPos(load("res://scenes/prefabs/Player.tscn"), self, Vector2(0, 0))
	$Clouds/AnimationPlayer.play("clouds")
	playerNode.start(name == "TitleLevel")

func get_tile_data(name: String, tile_pos: Vector2) -> Variant:
	var data: TileData = $Map.get_cell_tile_data(2, tile_pos)
	if data != null:
		return data.get_custom_data(name)
	return null

func get_all_tile_data(tile_pos: Vector2) -> TileData:
	return $Map.get_cell_tile_data(2, tile_pos)

func get_tile_id(cell_pos: Vector2i) -> Vector2i:
	return $Map.get_cell_atlas_coords(2, cell_pos)

func change_tile(tile_pos: Vector2i, tile_id: Vector2i):
	$Map.set_cell(2, tile_pos, 1, tile_id, 0)

func replace_tile_by(old_tile_id: Vector2i, new_tile_id: Vector2i):
	for cell_pos in $Map.get_used_cells_by_id(2, -1, old_tile_id):
		change_tile(cell_pos, new_tile_id)
