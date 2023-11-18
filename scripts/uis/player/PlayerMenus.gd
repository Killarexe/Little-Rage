extends Control

@onready var player_status: CanvasLayer = $PlayerStatus

func _unhandled_key_input(event: InputEvent):
	if event is InputEventKey:
		if event.is_action_pressed("ui_enable"):
			visible = !visible
			Overlay.visible = visible
			player_status.visible = visible
