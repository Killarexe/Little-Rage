extends CanvasLayer

@export var player: PlayerComponent
@onready var mobile_control: Control = $MobileControl

func _ready() -> void:
	mobile_control.visible = player.controllable && Game.is_mobile
