extends ItemList
class_name ToolsList

@export var brush: BrushComponent

func _ready() -> void:
  item_selected.connect(on_selected)
  brush.on_change_bush_type.connect(on_brush_change_type)
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

func on_brush_change_type(type: BrushComponent.BrushTypes) -> void:
  if brush.erase:
    select(0)
    return
  match type:
    BrushComponent.BrushTypes.PEN:
      select(1)
    BrushComponent.BrushTypes.RECTANGLE:
      select(2)
    BrushComponent.BrushTypes.CIRCLE:
      select(3)
