extends Node
class_name LevelPlayer

enum Mode {
	PLAY,
	EDIT
}

@export_category("Level Dependencies")
@export var ground: TileMapLayer
@export var background: TileMapLayer
@export_category("Level Settings")
@export var mode: Mode = Mode.PLAY
@export var start_pos: Vector2 = Vector2.ZERO

var player_prefab: Resource = load("res://scenes/bundles/player/Player.tscn")

func _ready() -> void:
	if Game.current_event == Game.Event.CHRISTMAS:
		var texture = load("res://assets/textures/tilesets/plains_christmas.png")
		ground.tile_set.get_source(1).texture = texture
		background.tile_set.get_source(1).texture = texture
	if mode == Mode.PLAY:
		spawn_player()

func finish_level(player: PlayerComponent, death: DeathComponent, time: PlayerTimer) -> void:
	var parent: Node = get_parent()
	if parent is LevelEditor:
		parent.switch_edit_mode()
	else:
		player.on_win.emit(time.get_time(), death.death_count)

func spawn_player() -> void:
	Game.instanceNodeAtPos(player_prefab, self, start_pos)

func filter_used_grass_cells() -> Array[Vector2i]:
	var used_grass_cells: Array[Vector2i] = [];
	for cell in ground.get_used_cells():
		var type: Vector2i = ground.get_cell_atlas_coords(cell)
		if type.x >= 0 && type.x <= 9 && type.y >= 0 && type.y <= 2:
			used_grass_cells.append(cell)
	return used_grass_cells

func set_mode(new_mode: Mode) -> void:
	mode = new_mode
	if mode == Mode.PLAY:
		spawn_player()
	else:
		for child in get_children():
			child.queue_free()
