extends Control
class_name DisableEditingCursor

@export var editor: LevelEditor

func _ready():
	mouse_entered.connect(editor.on_mouse_entered)
	mouse_exited.connect(editor.on_mouse_exited)
