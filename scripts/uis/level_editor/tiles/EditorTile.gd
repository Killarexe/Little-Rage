extends ResourceElement
class_name EditorTile

@export_category("Static Tiles propeties")
@export var tile_dictionary: Dictionary = {}
@export var icon_region: Rect2i = Rect2i(-1, -1, -1, -1)
@export var center_tile: Vector2i = Vector2i.ZERO
@export var terrain: int = -1
@export_category("Scene Tiles properties")
@export var scene_tile_id: int = -1

func new(tiles: Dictionary) -> void:
	self.tile_dictionary = tiles

func get_icon(level: LevelPlayer) -> ImageTexture:
	for tile_position in tile_dictionary.keys():
		var tile_id: Vector2i = tile_dictionary.get(tile_position)
		var atlas_coord: Vector2i = tile_id * Vector2i(16, 16)
		var region: Rect2i = icon_region
		if icon_region == Rect2i(-1, -1, -1, -1):
			region = Rect2i(atlas_coord, Vector2i(16, 16))
		return ImageTexture.create_from_image(level.ground.tile_set.get_source(1).texture.get_image().get_region(region))
	return ImageTexture.new()

func get_size() -> Vector2:
	if icon_region == Rect2i(-1, -1, -1, -1):
		return Vector2(16, 16)
	return icon_region.size

func place(level_map: LevelPlayer, tile_pos: Vector2i, place_background: bool = false) -> void:
	var layer: TileMapLayer = level_map.ground
	if place_background:
		layer = level_map.background
	if scene_tile_id >= 0:
		layer.set_cell(tile_pos, 0, Vector2i.ZERO, scene_tile_id)
		return
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
