extends CharacterBody2D
class_name PlayerMovement

@export var controllable: bool = true
@export var can_pause: bool = true
@export var interactable: bool = true
@export var camera_enabled: bool = true
@export var override_skin: String = ""
@export var override_hat: String = ""

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

var y_limit: int = Level.DEFAULT_Y_LIMIT

@export var motion: Vector2 = Vector2()
var knockback: Vector2 = Vector2.ZERO
var spawn_point: Vector2 = Vector2()

var movement_array: Array[String] = [
	"left",
	"right",
	"jump",
	"down"
]

func _ready():
	camera_enabled = LocalMultiplayer.is_enabled
	Game.can_pause = can_pause
	spawn_point = global_position
	var current_level: Level = LevelManager.get_current_level()
	if current_level != null:
		y_limit = LevelManager.get_current_level().y_limit
	
	if controllable && !LevelManager.current_level.is_empty():
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	if !override_skin.is_empty():
		skin.texture = PlayerSkinManager.get_skin(override_skin).texture
	if !override_hat.is_empty():
		skin.hat_sprite.texture = PlayerHatManager.get_hat(override_hat).texture

func _physics_process(delta: float):
	check_speed_and_timers(delta)
	check_input()
	handle_jump()
	set_velocity(motion)
	set_up_direction(UP)
	move_and_slide()
	knockback = lerp(knockback, Vector2.ZERO, 0.1)
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
	motion += knockback

func check_input():
	if controllable:
		if Input.is_action_pressed(movement_array[0]):
			skin.flip_h = true
			motion.x -= ACCEL
		elif Input.is_action_pressed(movement_array[1]):
			skin.flip_h = false
			motion.x += ACCEL
		else:
			motion.x = lerpf(motion.x, 0, 0.2)
		
		if Input.is_action_pressed(movement_array[2]):
			jump_timer = JUMP_TIME
			
		if jump_timer > 0 && !Input.is_action_pressed(movement_array[2]):
			jump_timer = 0
			if(motion.y < 0):
				motion.y = motion.y * 0.5
	else:
		motion.x = lerpf(motion.x, 0, 0.2)

func handle_jump():
	if is_on_floor():
		if ground_timer < GROUND_TIME - 0.1:
			PlayerParticleManager.spawn_particle(get_parent(), global_position + Vector2(0, 16), PlayerParticle.Type.JUMP)
			animation.stop()
			animation.play("PlayerAnimations/land")
		if abs(velocity.x) >= MAX_SPEED * 0.75:
			PlayerParticleManager.spawn_particle(get_parent(), global_position + Vector2(0, 16), PlayerParticle.Type.STEP)
		ground_timer = GROUND_TIME
	if (jump_timer > 0) && (ground_timer > 0):
		animation.play("PlayerAnimations/jump")
		sound_effect_manager.play_sfx("jump")
		PlayerParticleManager.spawn_particle(get_parent(), global_position + Vector2(0, 16), PlayerParticle.Type.JUMP)
		motion.y = -JUMP_FORCE
		jump_timer = 0
		ground_timer = 0

func die():
	sound_effect_manager.play_sfx("die")
	death_count += 1
	on_death.emit(death_count)
	global_position = spawn_point

func finish_level():
	if !LevelManager.current_level.is_empty():
		on_win.emit(timer.get_time(), death_count)
	else:
		#FIXME: Bad code...
		get_parent().get_parent().switch_edit_mode()
		pass

#----------
#Animation purpuse only!
#----------

func flip_sprite():
	skin.flip_h = !skin.flip_h

func jump_player():
	jump_timer = JUMP_TIME

func end_jump():
	jump_timer = 0
