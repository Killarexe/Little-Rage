extends Control
class_name LevelEditorTools

signal on_tool_set(index: int)

func _on_item_list_item_selected(index: int) -> void:
	on_tool_set.emit(index)
