extends PlayerDummyMovement
class_name PlayerControllerComponent

@export_category("Component requirement")
@export var skin: PlayerSkinSprite
@export var hat: PlayerHatSprite

func _ready() -> void:
	super._ready()
	if !LevelManager.current_level.is_empty():
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _physics_process(_delta: float) -> void:
	motion.y += GRAVITY
	if motion.y > MAX_FALL_SPEED:
		motion.y = MAX_FALL_SPEED
	handle_jump()
	check_input()
	player.set_velocity(motion)
	player.move_and_slide()
	motion = player.velocity
	motion.x = clampf(motion.x, -MAX_SPEED, MAX_SPEED)

func check_input() -> void:
	if Input.is_action_pressed("left"):
		skin.flip_h = true
		hat.flip_h = true
		motion.x -= ACCEL
	elif Input.is_action_pressed("right"):
		skin.flip_h = false
		hat.flip_h = false
		motion.x += ACCEL
	else:
		motion.x = lerpf(motion.x, 0.0, 0.2)
	
	if Input.is_action_pressed("jump"):
		jump_timer = JUMP_TIME
	
	if jump_timer > 0 && !Input.is_action_pressed("jump"):
		jump_timer = 0
		if(motion.y < 0):
			motion.y = motion.y * 0.5
