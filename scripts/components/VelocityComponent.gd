extends Node
class_name VelocityComponent

@export_category("Component requirement")
@export var body: CharacterBody2D

@export_category("Movement settings")
@export_range(4.0, 14.0) var ACCEL: float = 7.5
@export_range(250.0, 1000.0) var MAX_FALL_SPEED: float = 500.0
@export_range(75.0, 400.0) var MAX_SPEED: float = 200.0

@export_category("Gravity settings")
@export var GRAVITY_DIRECTION: Vector2 = Vector2(0, -1)
@export_range(0.0, 40.0) var GRAVITY: float = 20.0

var motion: Vector2 = Vector2()

func _physics_process(_delta: float) -> void:
	motion.y += GRAVITY
	if motion.y > MAX_FALL_SPEED:
		motion.y = MAX_FALL_SPEED
	if body:
		body.set_velocity(motion)
		body.set_up_direction(GRAVITY_DIRECTION)
		body.move_and_slide()
		motion = body.velocity
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
