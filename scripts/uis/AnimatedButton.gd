extends Button
class_name AnimatedButton

@export var start_animation: bool = false
@export var mouse_over_animation: bool = false
@export var clicked_animation: bool = false

@export var start_animation_delay: float = 0.0

func _on_pressed():
	if clicked_animation:
		pass

func _on_mouse_entered():
	if mouse_over_animation:
		pass

func _on_mouse_exited():
	if mouse_over_animation:
		pass

func _process(delta: float):
	if start_animation:
		pass
