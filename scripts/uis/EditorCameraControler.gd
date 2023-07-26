extends Camera2D
class_name EditorCameraControler

signal on_clicked(position: Vector2)

@export var debug_mode: bool = false

@export var rotate_speed: float = 1.0
@export var zoom_speed: float = 0.1
@export var pan_speed: float = 1.0

@export var can_rotate: bool = false
@export var can_zoom: bool = false
@export var can_pan: bool = false

var touch_points: Dictionary = {}
var is_panning: bool = false

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
		emit_signal("screen_touched", event.position)
	else:
		touch_points.erase(event.index)
	
	if touch_points.size() == 2:	
		var touch_point_positions = touch_points.values()
		

func handle_drag(event: InputEventScreenDrag):
	touch_points[event.index] = event.position
	if touch_points.size() == 1:
		if can_pan:
			offset -= event.relative * pan_speed

func handle_mouse_zoom(event: InputEventMouseButton):
	if event.is_pressed() && can_zoom:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(zoom_speed, zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(zoom_speed, zoom_speed)

func handle_mouse_pan(event: InputEventMouseMotion):
	if is_panning && can_pan:
		offset -= event.relative * pan_speed

func _process(_delta):
	is_panning = Input.is_action_pressed("middle_click") && !(Global.is_mobile || debug_mode)
