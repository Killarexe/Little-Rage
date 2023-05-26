extends TileMap
class_name LevelPlayer

enum Mode{
	PLAY,
	EDIT
}

@export var mode: Mode = Mode.PLAY
@export var start_pos: Vector2 = Vector2()

var player: Resource = load("res://scenes/instances/Player.tscn")

func _ready():
	if mode == Mode.PLAY:
		Global.instanceNodeAtPos(player, self, start_pos)

func filter_used_grass_cells() -> Array[Vector2i]:
	var used_grass_cells: Array[Vector2i] = [];
	for cell in get_used_cells(0):
		var type: Vector2i = get_cell_atlas_coords(0, cell)
		if type.x >=0 && type.x <= 9 && type.y >= 0 && type.y <= 2:
			used_grass_cells.append(cell)
	return used_grass_cells

func change_tile_and_update(tile_pos: Vector2i, tile_id: Vector2i):
	set_cell(0, tile_pos, 1, tile_id, 0)
	set_cells_terrain_connect(0, filter_used_grass_cells(), 0, 0, false)

func remove_tile_and_update(tile_pos: Vector2i):
	set_cell(0, tile_pos, 1, Vector2i(-1, -1), 0)
	set_cells_terrain_connect(0, filter_used_grass_cells(), 0, 0, false)

func set_mode(new_mode: Mode):
	mode = new_mode
	if mode == Mode.PLAY:
		Global.instanceNodeAtPos(player, self, start_pos)
	else:
		for child in get_children():
			child.queue_free()
