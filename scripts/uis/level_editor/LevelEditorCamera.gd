extends Node
class_name LevelEditorCamera

@export var camera: Camera2D
@export var bush: BrushComponent

@export var debug_mode: bool = false

@export var rotate_speed: float = 1.0
@export var zoom_speed: float = 0.1
@export var pan_speed: float = 1.0

var start_zoom: Vector2 = Vector2()

var touch_points: Dictionary = {}

var start_distance: float = 0.0
var current_angle: float = 0.0
var start_angle: float = 0.0

var is_panning: bool = false
var is_drag: bool = false
var can_move: bool = true

func _unhandled_input(event):
	if !(Game.is_mobile || debug_mode):
		if event is InputEventMouseButton:
			handle_mouse_zoom(event)
		if event is InputEventMouseMotion:
			handle_mouse_pan(event)

func _input(event):
	if Game.is_mobile || debug_mode:
		if event is InputEventScreenTouch:
			handle_touch(event)
		elif event is InputEventScreenDrag:
			is_drag = true
			handle_drag(event)

func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		touch_points[event.index] = event.position
	else:
		touch_points.erase(event.index)
	if touch_points.size() > 0:
		var viewport_size: Vector2 = Vector2(1280.0, 720.0)
		var touch_position: Vector2 = touch_points.values()[0]
		var touch_position_in_viewport: Vector2 = touch_position - viewport_size / 2.0
		var touch_position_in_zoomed_viewport: Vector2 = touch_position_in_viewport / camera.zoom
		var touch_position_in_world: Vector2 = touch_position_in_zoomed_viewport + camera.position
		
		print_debug("Touch pos: " + str(touch_position))
		print_debug("Touch pos in view: " + str(touch_position_in_viewport))
		print_debug("Touch pos in zoomed: " + str(touch_position_in_zoomed_viewport))
		print_debug("Touch pos in world: " + str(touch_position_in_world))
		print_debug("Erase: " + str(bush.erase))
		
		bush.brush(touch_position)
	else:
		if touch_points.size() == 2:
			var touch_point_positions = touch_points.values()
			start_distance = touch_point_positions[0].distance_to(touch_point_positions[1])
			start_angle = get_angle(touch_point_positions[0], touch_point_positions[1])
			start_zoom = camera.zoom
		elif touch_points.size() < 2:
			start_distance = 0
			is_drag = false

func handle_drag(event: InputEventScreenDrag):
	touch_points[event.index] = event.position
	if touch_points.size() == 1:
		camera.position -= event.relative.rotated(camera.rotation) * pan_speed / camera.zoom.x
	elif touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		var current_distance: float = touch_point_positions[0].distance_to(touch_point_positions[1])
		var zoom_factor: float = start_distance / current_distance 
		set_zoom_with_limit(start_zoom / zoom_factor)

func handle_mouse_zoom(event: InputEventMouseButton):
	if event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			set_zoom_with_limit(camera.zoom + Vector2(zoom_speed, zoom_speed))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			set_zoom_with_limit(camera.zoom - Vector2(zoom_speed, zoom_speed))

func set_zoom_with_limit(new_zoom: Vector2):
	camera.zoom = Vector2(clamp(new_zoom.x, 1, 4), clamp(new_zoom.y, 1, 4))

func handle_mouse_pan(event: InputEventMouseMotion):
	if is_panning:
		camera.position -= event.relative.rotated(camera.rotation) * pan_speed  / camera.zoom.x

func _process(delta: float):
	if !(Game.is_mobile || debug_mode) && can_move:
		is_panning = Input.is_action_pressed("middle_click")
		if Input.is_action_pressed("left_click"):
			bush.erase = false
			bush.brush(camera.get_global_mouse_position())
		elif Input.is_action_pressed("right_click"):
			bush.erase = true
			bush.brush(camera.get_global_mouse_position())
		
		if Input.is_action_pressed("left"):
			camera.position.x -= 400 / camera.zoom.x * delta
		if Input.is_action_pressed("right"):
			camera.position.x += 400 / camera.zoom.x * delta
		if Input.is_action_pressed("jump"):
			camera.position.y -= 400 / camera.zoom.y * delta
		if Input.is_action_pressed("down"):
			camera.position.y += 400 / camera.zoom.y * delta

func get_angle(p1: Vector2, p2: Vector2) -> float:
	var delta: Vector2 = p1 - p2
	return fmod(atan2(delta.y, delta.x) + PI, 2 * PI)
