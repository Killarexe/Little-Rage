extends Node
class_name LevelEditorUIElement

@export var control: Control
@export var brush: BrushComponent

func _ready() -> void:
  if control == null:
    control = get_parent()
  control.mouse_entered.connect(func(): brush.enable = false)
  control.mouse_exited.connect(func(): brush.enable = true)
