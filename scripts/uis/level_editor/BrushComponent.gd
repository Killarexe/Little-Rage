extends Node
class_name BrushComponent

enum BrushTypes {
	PEN,
	RECTANGLE,
	CIRCLE
}

@export_category("Dependencies")
@export var tile_sprite: Sprite2D
@export var level: LevelPlayer

@export_category("Parameters")
@export var selected_tile: EditorTile
@export var enable: bool = true
@export var erase: bool = false
@export var brush_type: BrushTypes = BrushTypes.PEN

func brush(start_position: Vector2, end_position: Vector2 = Vector2.ZERO):
	if !enable:
		return
	if erase:
		level.ground.set_cell(start_position / 16, 1)
	else:
		selected_tile.place(level, start_position / 16)
