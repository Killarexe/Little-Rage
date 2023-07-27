extends Camera2D
class_name EditorCameraControler

signal on_clicked(position: Vector2, placeing: bool)

@export var debug_mode: bool = false

@export var rotate_speed: float = 1.0
@export var zoom_speed: float = 0.1
@export var pan_speed: float = 1.0

@export var can_rotate: bool = false
@export var can_zoom: bool = false
@export var can_pan: bool = false

var start_zoom: Vector2 = Vector2()
var touch_points: Dictionary = {}
var start_distance: float = 0.0
var current_angle: float = 0.0
var start_angle: float = 0.0
var is_panning: bool = false
var placing: bool = true

func _unhandled_input(event):
	if !(Global.is_mobile || debug_mode):
		if event is InputEventMouseButton:
			handle_mouse_zoom(event)
		if event is InputEventMouseMotion:
			handle_mouse_pan(event)

func _input(event):
	if Global.is_mobile || debug_mode:
		if event is InputEventScreenTouch:
			handle_touch(event)
		elif event is InputEventScreenDrag:
			handle_drag(event)

func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		touch_points[event.index] = event.position
	else:
		touch_points.erase(event.index)
	
	if touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		start_distance = touch_point_positions[0].distance_to(touch_point_positions[1])
		start_angle = get_angle(touch_point_positions[0], touch_point_positions[1])
		start_zoom = zoom
	elif touch_points.size() < 2:
		start_distance = 0
	if touch_points.size() == 1:
		emit_signal("on_clicked", touch_points.values()[0], placing)

func handle_drag(event: InputEventScreenDrag):
	touch_points[event.index] = event.position
	if touch_points.size() == 1:
		if can_pan:
			offset -= event.relative.rotated(rotation) * pan_speed / zoom.x
	elif touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		var current_distance: float = touch_point_positions[0].distance_to(touch_point_positions[1])
		var current_angle: float = get_angle(touch_point_positions[0], touch_point_positions[1])
		var zoom_factor: float = start_distance / current_distance 
		if can_zoom:
			set_zoom_with_limit(start_zoom / zoom_factor)
		if can_rotate:
			rotation -= (current_angle - start_angle) * rotate_speed
			start_angle = current_angle

func handle_mouse_zoom(event: InputEventMouseButton):
	if event.is_pressed() && can_zoom:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			set_zoom_with_limit(zoom + Vector2(zoom_speed, zoom_speed))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			set_zoom_with_limit(zoom - Vector2(zoom_speed, zoom_speed))

func set_zoom_with_limit(new_zoom: Vector2):
	zoom = Vector2(clamp(new_zoom.x, 0.1, 10), clamp(new_zoom.y, 0.1, 10))

func handle_mouse_pan(event: InputEventMouseMotion):
	if is_panning && can_pan:
		offset -= event.relative.rotated(rotation) * pan_speed  / zoom.x

func _process(_delta):
	is_panning = Input.is_action_pressed("middle_click") && !(Global.is_mobile || debug_mode)
	if Input.is_action_pressed("left_click"):
		emit_signal("on_clicked", get_global_mouse_position(), true)
	elif Input.is_action_pressed("right_click"):
		emit_signal("on_clicked", get_global_mouse_position(), false)

func _on_eraser_button_toggled(button_pressed: bool):
	placing = button_pressed

func get_angle(p1: Vector2, p2: Vector2) -> float:
	var delta: Vector2 = p1 - p2
	return fmod(atan2(delta.y, delta.x) + PI, 2 * PI)
