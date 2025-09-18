extends Control
class_name PlayerMenus

@onready var player_status: CanvasLayer = $PlayerStatus
@onready var mobile_control: CanvasLayer = $MobileControl

func _ready() -> void:
  mobile_control.visible = Game.is_mobile

func _unhandled_key_input(event: InputEvent) -> void:
  if event is InputEventKey:
    if event.is_action_pressed("ui_enable"):
      visible = !visible
      Overlay.visible = visible
      player_status.visible = visible
