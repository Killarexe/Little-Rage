extends Node
class_name PlayerDummyMovement

@export_category("Component requirement")
@export var player: CharacterBody2D
@export var animation: AnimationPlayer
@export var sound_effect_player: SoundEffectPlayer

@export_category("Player movement settings")
@export_range(4.0, 14.0) var ACCEL: float = 7.5
@export_range(250.0, 1000.0) var MAX_FALL_SPEED: float = 500.0
@export_range(75.0, 400.0) var MAX_SPEED: float = 200.0
@export_range(200.0, 800.0) var JUMP_FORCE: float = 440.0

@export_category("Player time settings")
@export_range(0.1, 0.5) var GROUND_TIME: float = 0.2
@export_range(0.1, 0.5) var JUMP_TIME: float = 0.2

@export_category("Gravity settings")
@export var GRAVITY_DIRECTION: Vector2 = Vector2(0, -1)
@export_range(0.0, 40.0) var GRAVITY: float = 20

@export var motion: Vector2 = Vector2()

var jump_timer: float = 0
var ground_timer: float = 0

func _ready() -> void:
	player.set_up_direction(GRAVITY_DIRECTION)

func _process(delta: float) -> void:
	update_timers(delta)

func _physics_process(_delta: float) -> void:
	motion.y += GRAVITY
	if motion.y > MAX_FALL_SPEED:
		motion.y = MAX_FALL_SPEED
	handle_jump()
	player.set_velocity(motion)
	player.move_and_slide()
	motion = player.velocity
	motion.x = clampf(motion.x, -MAX_SPEED, MAX_SPEED)

func update_timers(delta: float) -> void:
	jump_timer -= delta
	ground_timer -= delta

func handle_jump() -> void:
	if player.is_on_floor():
		if ground_timer < GROUND_TIME - 0.1:
			PlayerParticleManager.spawn_particle(player.get_parent(), player.global_position + Vector2(0, 16), PlayerParticle.Type.JUMP)
			animation.stop()
			animation.play("PlayerAnimations/land")
		if abs(player.velocity.x) >= MAX_SPEED * 0.75:
			PlayerParticleManager.spawn_particle(player.get_parent(), player.global_position + Vector2(0, 16), PlayerParticle.Type.STEP)
		ground_timer = GROUND_TIME
	if (jump_timer > 0) && (ground_timer > 0):
		animation.play("PlayerAnimations/jump")
		sound_effect_player.play_sfx("jump")
		PlayerParticleManager.spawn_particle(player.get_parent(), player.global_position + Vector2(0, 16), PlayerParticle.Type.JUMP)
		motion.y = -JUMP_FORCE
		jump_timer = 0
		ground_timer = 0
