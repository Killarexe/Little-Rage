extends Node
class_name LevelEditorCamera

@export var camera: Camera2D
@export var brush: BrushComponent

@export var debug_mode: bool = false

@export var rotate_speed: float = 1.0
@export var zoom_speed: float = 0.1
@export var pan_speed: float = 1.0

var start_zoom: Vector2 = Vector2()

var touch_points: Dictionary[int, Vector2] = {}
var touch_start_positions: Dictionary[int, Vector2] = {}

var start_distance: float = 0.0
var current_angle: float = 0.0
var start_angle: float = 0.0

var is_panning: bool = false
var is_drag: bool = false
var can_move: bool = true
var is_drawing: bool = false

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

func screen_to_world(screen_position: Vector2) -> Vector2:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var viewport_position = screen_position - viewport_size / 2.0
	var world_position = viewport_position / camera.zoom + camera.position
	return world_position

func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		touch_points[event.index] = event.position
		touch_start_positions[event.index] = event.position
		
		if touch_points.size() == 1 && event.index == 0:
			is_drawing = true
			brush.erase = false
			if brush.brush_type == BrushComponent.BrushTypes.RECTANGLE:
				var world_pos: Vector2 = screen_to_world(event.position)
				touch_start_positions[event.index] = world_pos
			else:
				var world_pos: Vector2 = screen_to_world(event.position)
				brush.brush(world_pos)
	else:
		if event.index == 0 && is_drawing:
			if brush.brush_type == BrushComponent.BrushTypes.RECTANGLE && touch_start_positions.has(0):
				var start_pos: Vector2 = touch_start_positions[0]
				var end_pos: Vector2 = screen_to_world(event.position)
				brush.brush(start_pos, end_pos)
			is_drawing = false
		
		touch_points.erase(event.index)
		touch_start_positions.erase(event.index)
		if touch_points.size() < 2:
			start_distance = 0
			is_drag = false

func handle_drag(event: InputEventScreenDrag):
	touch_points[event.index] = event.position
	is_drag = true
	
	if touch_points.size() == 1 && event.index == 0 && is_drawing:
		if !brush.brush_type == BrushComponent.BrushTypes.RECTANGLE:
			var world_pos = screen_to_world(event.position)
			brush.brush(world_pos)
	elif touch_points.size() == 1 && !is_drawing:
		camera.position -= event.relative.rotated(camera.rotation) * pan_speed / camera.zoom.x
	elif touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		var current_distance: float = touch_point_positions[0].distance_to(touch_point_positions[1])
		
		if start_distance == 0:
			start_distance = current_distance
			start_zoom = camera.zoom
		else:
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

var long_press_timer: float = 0.0
var long_press_threshold: float = 0.5
var long_press_move_threshold: float = 20.0  # pixels
var long_press_detected: bool = false

func _process(delta: float):
	if (Game.is_mobile || debug_mode) && touch_points.size() == 1 && touch_points.has(0) && !is_drag:
		long_press_timer += delta
		var distance = touch_points[0].distance_to(touch_start_positions[0])
		if long_press_timer > long_press_threshold && distance < long_press_move_threshold && !long_press_detected:
			brush.erase = true
			long_press_detected = true
			if OS.has_feature("vibrate"):
				Input.vibrate_handheld(100)
	elif (Game.is_mobile || debug_mode) && (touch_points.size() != 1 || !touch_points.has(0)):
		long_press_timer = 0.0
		long_press_detected = false
	
	if !(Game.is_mobile || debug_mode) && can_move:
		is_panning = Input.is_action_pressed("middle_click")
		var is_rect_tool: bool = Input.is_action_pressed("shift")
		if is_rect_tool && brush.enable:
			brush.brush_type = BrushComponent.BrushTypes.RECTANGLE
			if Input.is_action_just_pressed("left_click"):
				brush.erase = false
				touch_points[0] = camera.get_global_mouse_position()
			elif Input.is_action_pressed("right_click"):
				brush.erase = true
				touch_points[0] = camera.get_global_mouse_position()
			if touch_points.values().size() != 0 && (Input.is_action_just_released("left_click") || Input.is_action_just_released("right_click")):
				brush.brush(touch_points[0], camera.get_global_mouse_position())
				touch_points.clear()
		elif brush.enable:
			brush.brush_type = BrushComponent.BrushTypes.PEN
			if Input.is_action_pressed("left_click"):
				brush.erase = false
				brush.brush(camera.get_global_mouse_position())
			elif Input.is_action_pressed("right_click"):
				brush.erase = true
				brush.brush(camera.get_global_mouse_position())
		
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
