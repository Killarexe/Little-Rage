extends ResourceElement
class_name EditorTile

@export var tile_dictionary: Dictionary = {}
@export var icon_region: Rect2i = Rect2i(-1, -1, -1, -1)

func new(tiles: Dictionary):
	self.tile_dictionary = tiles

func on_place(_level_map: LevelPlayer, _tile_pos: Vector2i):
	#for position in tile_dictionary.keys():
	#	level_map.change_tile_and_update(tile_pos + position, tile_dictionary.get(position))
	pass
