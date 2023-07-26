extends Control

@export var visible_on_mobile: bool = true

func _ready():
	if Global.is_mobile:
		visible = visible_on_mobile
	else:
		visible = !visible_on_mobile
