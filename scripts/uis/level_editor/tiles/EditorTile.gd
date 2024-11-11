extends ResourceElement
class_name EditorTile

@export var tile_dictionary: Dictionary = {}
@export var icon_region: Rect2i = Rect2i(-1, -1, -1, -1)

func new(tiles: Dictionary):
	self.tile_dictionary = tiles

func place(level_map: LevelPlayer, tile_pos: Vector2i):
	for position in tile_dictionary.keys():
		level_map.ground.set_cell(position + tile_pos, 1, tile_dictionary.get(position))
