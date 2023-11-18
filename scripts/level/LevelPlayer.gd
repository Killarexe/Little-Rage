extends TileMap
class_name LevelPlayer

const ON_TILE: Vector2i = Vector2i(0, 5)
const OFF_TILE: Vector2i = Vector2i(0, 6)

const RED_FULL_TILE: Vector2i = Vector2i(1, 5)
const RED_EMPTY_TILE: Vector2i = Vector2i(1, 6)

const BLUE_FULL_TILE: Vector2i = Vector2i(1, 7)
const BLUE_EMPTY_TILE: Vector2i = Vector2i(1, 8)

const CHECKPOINT_ON_TILE: Vector2i = Vector2i(2, 3)
const CHECKPOINT_OFF_TILE: Vector2i = Vector2i(4, 3)

const BLUE_SPIKE_TILE_DOWN_ON: Vector2i = Vector2i(2, 9)
const BLUE_SPIKE_TILE_DOWN_OFF: Vector2i = Vector2i(4, 9)
const RED_SPIKE_TILE_DOWN_ON: Vector2i = Vector2i(6, 9)
const RED_SPIKE_TILE_DOWN_OFF: Vector2i = Vector2i(8, 9)

const BLUE_SPIKE_TILE_UP_ON: Vector2i = Vector2i(2, 8)
const BLUE_SPIKE_TILE_UP_OFF: Vector2i = Vector2i(4, 8)
const RED_SPIKE_TILE_UP_ON: Vector2i = Vector2i(6, 8)
const RED_SPIKE_TILE_UP_OFF: Vector2i = Vector2i(8, 8)

const BLUE_SPIKE_TILE_LEFT_ON: Vector2i = Vector2i(3, 8)
const BLUE_SPIKE_TILE_LEFT_OFF: Vector2i = Vector2i(5, 8)
const RED_SPIKE_TILE_LEFT_ON: Vector2i = Vector2i(7, 8)
const RED_SPIKE_TILE_LEFT_OFF: Vector2i = Vector2i(9, 8)

const BLUE_SPIKE_TILE_RIGHT_ON: Vector2i = Vector2i(3, 9)
const BLUE_SPIKE_TILE_RIGHT_OFF: Vector2i = Vector2i(5, 9)
const RED_SPIKE_TILE_RIGHT_ON: Vector2i = Vector2i(7, 9)
const RED_SPIKE_TILE_RIGHT_OFF: Vector2i = Vector2i(9, 9)

enum Mode{
	PLAY,
	EDIT
}

@export var mode: Mode = Mode.PLAY
@export var start_pos: Vector2 = Vector2()
var player_prefab: Resource = load("res://scenes/instances/level/player/Player.tscn")
var countdown_prefab: Resource = load("res://scenes/instances/level/player/uis/countdown.tscn")

func _ready():
	if mode == Mode.PLAY:
		MusicManager.play_music("level_plains")
		spawn_player()
		Global.instanceNode(countdown_prefab, self)

func spawn_player():
	var player = Global.instanceNodeAtPos(player_prefab, self, start_pos)
	player.connect("on_switch_color", switch_colors)
	player.connect("on_setting_spawnpoint", set_spawnpoint)

func filter_used_grass_cells() -> Array[Vector2i]:
	var used_grass_cells: Array[Vector2i] = [];
	for cell in get_used_cells(0):
		var type: Vector2i = get_cell_atlas_coords(0, cell)
		if type.x >= 0 && type.x <= 9 && type.y >= 0 && type.y <= 2:
			used_grass_cells.append(cell)
	return used_grass_cells

#Color: true = red, false = blue
func switch_colors(color: bool):
	if color:
		replace_tile_by(ON_TILE, OFF_TILE)
		
		replace_tile_by(RED_FULL_TILE, RED_EMPTY_TILE)
		replace_tile_by(RED_SPIKE_TILE_DOWN_ON, RED_SPIKE_TILE_DOWN_OFF)
		replace_tile_by(RED_SPIKE_TILE_UP_ON, RED_SPIKE_TILE_UP_OFF)
		replace_tile_by(RED_SPIKE_TILE_LEFT_ON, RED_SPIKE_TILE_LEFT_OFF)
		replace_tile_by(RED_SPIKE_TILE_RIGHT_ON, RED_SPIKE_TILE_RIGHT_OFF)
		
		replace_tile_by(BLUE_EMPTY_TILE, BLUE_FULL_TILE)
		replace_tile_by(BLUE_SPIKE_TILE_DOWN_OFF, BLUE_SPIKE_TILE_DOWN_ON)
		replace_tile_by(BLUE_SPIKE_TILE_UP_OFF, BLUE_SPIKE_TILE_UP_ON)
		replace_tile_by(BLUE_SPIKE_TILE_LEFT_OFF, BLUE_SPIKE_TILE_LEFT_ON)
		replace_tile_by(BLUE_SPIKE_TILE_RIGHT_OFF, BLUE_SPIKE_TILE_RIGHT_ON)
	else:
		replace_tile_by(OFF_TILE, ON_TILE)
		
		replace_tile_by(BLUE_FULL_TILE, BLUE_EMPTY_TILE)
		replace_tile_by(BLUE_SPIKE_TILE_DOWN_ON, BLUE_SPIKE_TILE_DOWN_OFF)
		replace_tile_by(BLUE_SPIKE_TILE_UP_ON, BLUE_SPIKE_TILE_UP_OFF)
		replace_tile_by(BLUE_SPIKE_TILE_LEFT_ON, BLUE_SPIKE_TILE_LEFT_OFF)
		replace_tile_by(BLUE_SPIKE_TILE_RIGHT_ON, BLUE_SPIKE_TILE_RIGHT_OFF)
		
		replace_tile_by(RED_EMPTY_TILE, RED_FULL_TILE)
		replace_tile_by(RED_SPIKE_TILE_DOWN_OFF, RED_SPIKE_TILE_DOWN_ON)
		replace_tile_by(RED_SPIKE_TILE_UP_OFF, RED_SPIKE_TILE_UP_ON)
		replace_tile_by(RED_SPIKE_TILE_LEFT_OFF, RED_SPIKE_TILE_LEFT_ON)
		replace_tile_by(RED_SPIKE_TILE_RIGHT_OFF, RED_SPIKE_TILE_RIGHT_ON)

func set_spawnpoint(cell_pos: Vector2):
	replace_tile_by(CHECKPOINT_ON_TILE, CHECKPOINT_OFF_TILE)
	set_cell(0, cell_pos, 1, CHECKPOINT_ON_TILE, 0)

func replace_tile_by(original_tile_id: Vector2i, new_tile_id: Vector2i):
	for cell in get_used_cells_by_id(0, 1, original_tile_id, 0):
		set_cell(0, Vector2(cell.x, cell.y), 1, new_tile_id, 0)

func change_tile_and_update(tile_pos: Vector2i, tile_id: Vector2i):
	set_cell(0, tile_pos, 1, tile_id, 0)
	set_cells_terrain_connect(0, filter_used_grass_cells(), 0, 0, false)

func remove_tile_and_update(tile_pos: Vector2i):
	set_cell(0, tile_pos, 1, Vector2i(-1, -1), 0)
	set_cells_terrain_connect(0, filter_used_grass_cells(), 0, 0, false)

func set_mode(new_mode: Mode):
	mode = new_mode
	if mode == Mode.PLAY:
		spawn_player()
	else:
		for child in get_children():
			child.queue_free()
