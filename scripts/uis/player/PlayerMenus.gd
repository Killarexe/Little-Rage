extends Control

func _unhandled_key_input(event: InputEvent):
	if event is InputEventKey:
		if event.is_action_pressed("ui_enable"):
			visible = !visible
			for child in get_children():
				child.visible = visible
			Overlay.visible = visible
