extends Control
class_name PlayerMenus

@export var player: PlayerMovement
@onready var player_status: CanvasLayer = $PlayerStatus
@onready var mobile_control: CanvasLayer = $MobileControl

func _ready():
	mobile_control.visible = player.controllable && Global.is_mobile

func _unhandled_key_input(event: InputEvent):
	if event is InputEventKey:
		if event.is_action_pressed("ui_enable"):
			visible = !visible
			Overlay.visible = visible
			player_status.visible = visible
