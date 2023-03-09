extends Node2D

var current_item
var can_place: bool = true
var is_panning: bool = true

@onready var level: Node2D = get_parent().get_node("Level")
@onready var camera_node: Node2D = get_parent().get_node("CameraContainer")
@onready var camera = camera_node.get_node("Camera2D")

func _ready():
	camera.current = true

func _process(delta):
	if OS.get_name() != "Android" or OS.get_name() != "iOS":
		global_position = get_global_mouse_position()
		if Input.is_action_just_pressed("mouse_right") and current_item != null:
			current_item = null
			$Sprite2D.texture = null
		if current_item != null and can_place and Input.is_action_just_pressed("mouse_left"):
			var new_item = current_item.instantiate()
			level.add_child(new_item)
			new_item.global_position = get_global_mouse_position()
		move_camera()
		is_panning = Input.is_action_pressed("mouse_middle")

func move_camera():
	if Input.is_action_pressed("ui_up"):
		camera_node.global_position.y -= 10
	if Input.is_action_pressed("ui_down"):
		camera_node.global_position.y += 10
	if Input.is_action_pressed("ui_left"):
		camera_node.global_position.x -= 10
	if Input.is_action_pressed("ui_right"):
		camera_node.global_position.x += 10

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				camera.zoom -= Vector2(0.1, 0.1)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				camera.zoom += Vector2(0.1, 0.1)
	if event is InputEventMouseMotion:
		if is_panning:
			camera.global_position -= event.relative * camera.zoom

func show_sprite(show: bool):
	if show:
		$Sprite2D.show()
	else:
		$Sprite2D.hide()
