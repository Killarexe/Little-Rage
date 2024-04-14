extends PlayerComponent
class_name PlayerDummyComponent

@export_category("Cosmetic components")
@export var player_skin: PlayerSkinSprite
@export var player_hat: PlayerHatSprite
@export_category("Cosmetic settings")
@export var override_hat_id: String
@export var override_skin_id: String

@export_category("Component requirement")
@export var animation: AnimationPlayer
@export var sound_effect_player: SoundEffectPlayer

@export_category("Player movement settings")
@export_range(200.0, 800.0) var JUMP_FORCE: float = 400.0

@export_category("Player time settings")
@export_range(0.1, 0.5) var GROUND_TIME: float = 0.2
@export_range(0.1, 0.5) var JUMP_TIME: float = 0.2

func _ready():
	player_skin.update_skin(override_skin_id)
	player_hat.update_hat(override_hat_id)

var jump_timer: float = 0
var ground_timer: float = 0

func _process(delta: float) -> void:
	super._process(delta)
	handle_jump()

func update_timers(delta: float) -> void:
	jump_timer -= delta
	ground_timer -= delta

func handle_jump() -> void:
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
		sound_effect_player.play_sfx("jump")
		PlayerParticleManager.spawn_particle(get_parent(), global_position + Vector2(0, 16), PlayerParticle.Type.JUMP)
		motion.y = -JUMP_FORCE
		jump_timer = 0
		ground_timer = 0

func flip_sprite():
	player_skin.flip_h = !player_skin.flip_h

func jump_player():
	jump_timer = JUMP_TIME
