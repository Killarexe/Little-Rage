extends Control
class_name MobileVisibility

@export var visible_on_mobile: bool = true

func _ready() -> void:
	if Game.is_mobile:
		visible = visible_on_mobile
	else:
		visible = !visible_on_mobile
