extends CharacterBody2D
class_name PlayerComponent

signal on_setting_spawnpoint(pos: Vector2)
signal on_switch_color(color: bool)
signal on_win(time: Array[int], death_count: int)
signal on_death(death_count: int)

@export_category("Movement settings")
@export_range(4.0, 14.0) var ACCEL: float = 7.5
@export_range(250.0, 1000.0) var MAX_FALL_SPEED: float = 500.0
@export_range(75.0, 400.0) var MAX_SPEED: float = 200.0

@export_category("Gravity settings")
@export var GRAVITY_DIRECTION: Vector2 = Vector2(0, -1)
@export_range(0.0, 40.0) var GRAVITY: float = 20

@export var motion: Vector2 = Vector2()

func _ready():
	set_up_direction(GRAVITY_DIRECTION)

func _process(_delta: float) -> void:
	motion.y += GRAVITY
	if motion.y > MAX_FALL_SPEED:
		motion.y = MAX_FALL_SPEED
	set_velocity(motion)
	move_and_slide()
	motion = velocity
	motion.x = clampf(motion.x, -MAX_SPEED, MAX_SPEED)
