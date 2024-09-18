extends ResourceElement
class_name EditorTile

@export var tile_dictionary: Dictionary = {}
@export var icon_region: Rect2i = Rect2i(-1, -1, -1, -1)

func new(tile_dictionary: Dictionary):
	self.tile_dictionary = tile_dictionary

func on_place(level_map: LevelPlayer, tile_pos: Vector2i):
	#for position in tile_dictionary.keys():
	#	level_map.change_tile_and_update(tile_pos + position, tile_dictionary.get(position))
	pass
