extends Node
class_name BrushComponent

enum BrushTypes {
	PEN,
	RECTANGLE,
	CIRCLE
}

@export_category("Dependencies")
@export var tile_sprite: Sprite2D
@export var tiles_list: TilesList
@export var level: LevelPlayer

@export_category("Parameters")
@export var selected_tile: EditorTile
@export var enable: bool = true
@export var erase: bool = false
@export var brush_type: BrushTypes = BrushTypes.PEN

func _ready() -> void:
	await tiles_list.ready
	tiles_list.create_list(load("res://assets/textures/tilesets/plains.png"))
	tiles_list.on_selected.connect(func(new_tile: EditorTile): selected_tile = new_tile)

func brush(start_position: Vector2, end_position: Vector2 = Vector2.ZERO):
	if !enable:
		return
	
	var start_tile_position: Vector2i = (start_position / 16.0).floor()
	var end_tile_position: Vector2i = (end_position / 16.0).floor()
	
	if erase:
		level.ground.set_cell(start_tile_position, 1)
		return
	match brush_type:
		BrushTypes.PEN:
			selected_tile.place(level, start_tile_position)
		BrushTypes.RECTANGLE:
			var first_tile_position: Vector2i = start_tile_position
			var last_tile_position: Vector2i = end_tile_position
			if start_tile_position < end_tile_position:
				first_tile_position = end_tile_position
				last_tile_position = start_tile_position
			for x in range(last_tile_position.x, first_tile_position.x):
				for y in range(last_tile_position.y, first_tile_position.y):
					selected_tile.place(level, Vector2i(x, y))
