extends ResourceElement
class_name EditorTile

@export var tile_dictionary: Dictionary = {}
@export var icon_region: Rect2i = Rect2i(-1, -1, -1, -1)
@export var terrain: int = -1

func new(tiles: Dictionary):
	self.tile_dictionary = tiles

func place(level_map: LevelPlayer, tile_pos: Vector2i, place_background: bool = false):
	var layer: TileMapLayer = level_map.ground
	if place_background:
		layer = level_map.background
	for position in tile_dictionary.keys():
		layer.set_cell(position + tile_pos, 1, tile_dictionary.get(position))
		if terrain >= 0:
			var poses: Array[Vector2i] = [
				tile_pos + Vector2i(-1, -1), tile_pos + Vector2i(0, -1), tile_pos + Vector2i(1, -1),
				tile_pos + Vector2i(-1, 0), tile_pos + Vector2i(0, 0), tile_pos + Vector2i(1, 0),
				tile_pos + Vector2i(-1, 1), tile_pos + Vector2i(0, 1), tile_pos + Vector2i(1, 1)
			]
			match terrain:
				0:
					poses = poses.filter(func(pos: Vector2i): return is_grass_cell(layer, pos))
			layer.set_cells_terrain_connect(poses, 0, terrain, false)

func is_grass_cell(layer: TileMapLayer, pos: Vector2i) -> bool:
	var atlas_pos: Vector2i = layer.get_cell_atlas_coords(pos)
	return atlas_pos.x >= 0 && atlas_pos.x <= 9 && atlas_pos.y >= 0 && atlas_pos.y <= 2
