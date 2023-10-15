extends CharacterBody2D
class_name PlayerMovement

@export var controllable: bool = true

@onready var timer: PlayerTimer = $Timer
@onready var skin: PlayerSkinSprite = $Skin
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sound_effect_manager: SoundEffectPlayer = $SoundEffectPlayer

signal on_setting_spawnpoint(pos: Vector2)
signal on_switch_color(color: bool)
signal on_win(time: Array[int], death_count: int)
signal on_death(death_count: int)

const MAX_FALL_SPEED: float = 500.0
const GROUND_TIME: float = 0.2
const JUMP_FORCE: float = 400.0
const JUMP_TIME: float = 0.2
const MAX_SPEED: float = 200.0
const ACCEL: float = 7.5
const UP: Vector2 = Vector2(0, -1)
const G: float = 20.0

var death_count: int = 0
var jump_timer: float = 0
var ground_timer: float = 0
var is_invinsible: bool = false
@export var motion: Vector2 = Vector2()
var previous_tile_type: int = 0
var spawn_point: Vector2 = Vector2()
var y_limit: int = Level.DEFAULT_Y_LIMIT

func _ready():
	spawn_point = global_position
	var current_level: Level = LevelManager.get_current_level()
	if current_level != null:
		y_limit = LevelManager.get_current_level().y_limit

func _physics_process(delta: float):
	check_speed_and_timers(delta)
	check_input()
	handle_jump()
	set_velocity(motion)
	set_up_direction(UP)
	move_and_slide()
	motion = velocity

func check_speed_and_timers(delta: float):
	if global_position.y >= y_limit:
		die()
	motion.y += G
	if(motion.y > MAX_FALL_SPEED):
		motion.y = MAX_SPEED
	jump_timer -= delta
	ground_timer -= delta
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)

func check_input():
	if controllable:
		if Input.is_action_pressed("left"):
			skin.flip_h = true
			motion.x -= ACCEL
		elif Input.is_action_pressed("right"):
			skin.flip_h = false
			motion.x += ACCEL
		else:
			motion.x = lerpf(motion.x, 0, 0.2)
		
		if Input.is_action_pressed("jump"):
			jump_timer = JUMP_TIME
	
	if jump_timer > 0 && !Input.is_action_pressed("jump"):
		jump_timer = 0
		if(motion.y < 0):
			motion.y = motion.y * 0.5

func handle_jump():
	if is_on_floor():
		if ground_timer < GROUND_TIME - 0.1:
			PlayerParticleManager.spawn_particle(get_parent(), global_position + Vector2(0, 16), PlayerParticle.Type.JUMP)
			animation.stop()
			animation.play("PlayerAnimations/land")
		if abs(velocity.x) >= MAX_SPEED:
			PlayerParticleManager.spawn_particle(get_parent(), global_position + Vector2(0, 16), PlayerParticle.Type.STEP)
		ground_timer = GROUND_TIME
	if (jump_timer > 0) && (ground_timer > 0):
		animation.play("PlayerAnimations/jump")
		sound_effect_manager.play_sfx("classic_jump")
		PlayerParticleManager.spawn_particle(get_parent(), global_position + Vector2(0, 16), PlayerParticle.Type.JUMP)
		motion.y = -JUMP_FORCE
		jump_timer = 0
		ground_timer = 0

func die():
	sound_effect_manager.play_rand_sfx(PlayerSoundEffect.Type.DIE)
	death_count += 1
	on_death.emit(death_count)
	global_position = spawn_point

func finish_level():
	if !LevelManager.current_level.is_empty():
		on_win.emit(timer.get_time(), death_count)
