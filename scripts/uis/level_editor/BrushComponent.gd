extends Node
class_name BrushComponent

enum BrushTypes {
	PEN,
	RECTANGLE,
	CIRCLE
}

signal on_change_bush_type(type: BrushTypes)

@export_category("Dependencies")
@export var camera: Camera2D
@export var tile_sprite: Sprite2D
@export var tiles_list: TilesList
@export var level: LevelPlayer

@export_category("Parameters")
@export var selected_tile: EditorTile
@export var enable: bool = true
@export var erase: bool = false
@export var brush_type: BrushTypes = BrushTypes.PEN:
	set(value):
		on_change_bush_type.emit(value)
		brush_type = value

var is_paused: bool = false

func _ready() -> void:
	tiles_list.on_selected.connect(set_selected_tile)

func brush_pen(tile_position: Vector2i) -> void:
	if erase:
		level.ground.set_cell(tile_position, 1)
	else:
		selected_tile.place(level, tile_position)

func brush_rectangle(start_tile_position: Vector2i, end_tile_position: Vector2i) -> void:
	var first_tile_position: Vector2i = start_tile_position
	var last_tile_position: Vector2i = end_tile_position
	if start_tile_position < end_tile_position:
		first_tile_position = end_tile_position
		last_tile_position = start_tile_position
	for x in range(last_tile_position.x, first_tile_position.x + 1):
		for y in range(last_tile_position.y, first_tile_position.y + 1):
			brush_pen(Vector2i(x, y))

func brush_circle(start_tile_position: Vector2i, end_tile_position: Vector2i) -> void:
	var radius: int = start_tile_position.distance_squared_to(end_tile_position)
	var first_tile_position: Vector2i = start_tile_position + Vector2i(radius, radius)
	var last_tile_position: Vector2i = start_tile_position - Vector2i(radius, radius)
	for x in range(last_tile_position.x, first_tile_position.x):
		for y in range(last_tile_position.y, first_tile_position.y):
			var tile_position: Vector2i = Vector2i(x, y)
			if start_tile_position.distance_squared_to(tile_position) <= radius:
				brush_pen(tile_position)

func brush(start_position: Vector2, end_position: Vector2 = Vector2.ZERO) -> void:
	if !enable || is_paused:
		return
	var start_tile_position: Vector2i = (start_position / 16.0).floor()
	var end_tile_position: Vector2i = (end_position / 16.0).floor()
	
	match brush_type:
		BrushTypes.PEN:
			brush_pen(start_tile_position)
		BrushTypes.RECTANGLE:
			brush_rectangle(start_tile_position, end_tile_position)
		BrushTypes.CIRCLE:
			brush_circle(start_tile_position, end_tile_position)

func _process(delta: float) -> void:
	tile_sprite.visible = enable && !erase && level.mode == LevelPlayer.Mode.EDIT && !is_paused
	if tile_sprite.visible:
		tile_sprite.position = (camera.get_global_mouse_position() / 16.0).floor() * 16 + selected_tile.get_size() / 2

func set_selected_tile(new_tile: EditorTile) -> void:
	selected_tile = new_tile
	tile_sprite.texture = new_tile.get_icon(level)
	tile_sprite.offset = new_tile.center_tile * 16
