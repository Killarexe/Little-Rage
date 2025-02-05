extends ItemList
class_name ToolsList

@export var brush: BrushComponent

func _ready() -> void:
	item_selected.connect(on_selected)
	select(2)

func on_selected(index: int) -> void:
	if index == 0:
		brush.erase = true
		brush.brush_type = BrushComponent.BrushTypes.PEN
		return
	match index:
		1:
			brush.brush_type = BrushComponent.BrushTypes.PEN
		2:
			brush.brush_type = BrushComponent.BrushTypes.RECTANGLE
		3:
			brush.brush_type = BrushComponent.BrushTypes.CIRCLE
