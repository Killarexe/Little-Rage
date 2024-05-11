extends Node
class_name PlayerControllerComponent

@export_category("Component requirement")
@export var player: PlayerComponent
@export var skin: PlayerSkinSprite
@export var hat: PlayerHatSprite
@export var animation: AnimationPlayer
@export var sound_effect_player: SoundEffectPlayer

@export_category("Player movement settings")
@export_range(200.0, 800.0) var JUMP_FORCE: float = 440.0

@export_category("Player time settings")
@export_range(0.1, 0.5) var GROUND_TIME: float = 0.2
@export_range(0.1, 0.5) var JUMP_TIME: float = 0.2

var jump_timer: float = 0
var ground_timer: float = 0

func _ready() -> void:
	if !LevelManager.current_level.is_empty():
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(delta: float) -> void:
	update_timers(delta)

func _physics_process(_delta: float) -> void:
	handle_jump()
	check_input()

func update_timers(delta: float) -> void:
	jump_timer -= delta
	ground_timer -= delta

func check_input() -> void:
	if Input.is_action_pressed("left"):
		skin.flip_h = true
		hat.flip_h = true
		player.motion.x -= player.ACCEL
	elif Input.is_action_pressed("right"):
		skin.flip_h = false
		hat.flip_h = false
		player.motion.x += player.ACCEL
	else:
		player.motion.x = lerpf(player.motion.x, 0.0, 0.2)
	
	if Input.is_action_pressed("jump"):
		jump_timer = JUMP_TIME
	
	if jump_timer > 0 && !Input.is_action_pressed("jump"):
		jump_timer = 0
		if(player.motion.y < 0):
			player.motion.y = player.motion.y * 0.5

func handle_jump() -> void:
	if player.is_on_floor():
		if ground_timer < GROUND_TIME - 0.1:
			PlayerParticleManager.spawn_particle(player.get_parent(), player.global_position + Vector2(0, 16), PlayerParticle.Type.JUMP)
			animation.stop()
			animation.play("PlayerAnimations/land")
		if abs(player.velocity.x) >= player.MAX_SPEED * 0.75:
			PlayerParticleManager.spawn_particle(player.get_parent(), player.global_position + Vector2(0, 16), PlayerParticle.Type.STEP)
		ground_timer = GROUND_TIME
	if (jump_timer > 0) && (ground_timer > 0):
		animation.play("PlayerAnimations/jump")
		sound_effect_player.play_sfx("jump")
		PlayerParticleManager.spawn_particle(player.get_parent(), player.global_position + Vector2(0, 16), PlayerParticle.Type.JUMP)
		player.motion.y = -JUMP_FORCE
		jump_timer = 0
		ground_timer = 0
