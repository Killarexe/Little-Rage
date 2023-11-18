extends CanvasLayer

@export var player: PlayerMovement
@onready var mobile_control: Control = $MobileControl

func _ready():
	mobile_control.visible = player.controllable && Global.is_mobile
