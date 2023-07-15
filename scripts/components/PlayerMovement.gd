extends CharacterBody2D
class_name PlayerMovement

@onready var timer: PlayerTimer = $Timer
@onready var skin: PlayerSkinSprite = $Skin
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sound_effect_manager: SoundEffectPlayer = $SoundEffectPlayer

signal on_win(time: Array[int])
signal on_death

const MAX_FALL_SPEED: float = 500.0
const GROUND_TIME: float = 0.2
const JUMP_FORCE: float = 350.0
const JUMP_TIME: float = 0.2
const MAX_SPEED: float = 200.0
const ACCEL: float = 7.5
const UP: Vector2 = Vector2(0, -1)
const G: float = 20.0

var jump_timer: float = 0
var ground_timer: float = 0
var is_invinsible: bool = false
var motion: Vector2 = Vector2()
var spawn_point: Vector2 = Vector2()
var y_limit: int = Level.DEFAULT_Y_LIMIT
var jump_particle: Resource = load("res://scenes/instances/JumpParticle.tscn")

func _ready():
	spawn_point = global_position
	animation_tree.active = true
	var current_level: Level = LevelManager.get_current_level()
	if current_level != null:
		y_limit = LevelManager.get_current_level().y_limit

func _physics_process(delta):
	if global_position.y >= y_limit:
		die()
	motion.y += G
	if(motion.y > MAX_FALL_SPEED):
		motion.y = MAX_SPEED
	jump_timer -= delta
	ground_timer -= delta
	
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	animation_tree["parameters/conditions/is_idle"] = velocity.x == 0
	animation_tree["parameters/conditions/is_moving"] = !animation_tree["parameters/conditions/is_idle"]
	scale.x = lerpf(scale.x, abs(velocity.x) / MAX_SPEED / 8 + 1, 0.2)
	scale.y = lerpf(scale.y, abs(motion.y) / MAX_FALL_SPEED / 3 + 1, 0.2)
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
	
	if is_on_floor():
		animation_tree["parameters/conditions/is_landing"] = ground_timer < 0
		if ground_timer < 0:
			is_invinsible = false
			Global.instanceNodeAtPos(jump_particle, get_parent(), global_position + Vector2(0, 16))
		ground_timer = GROUND_TIME
	animation_tree["parameters/conditions/is_jumping"] = (jump_timer > 0) && (ground_timer > 0)
	if (jump_timer > 0) && (ground_timer > 0):
		sound_effect_manager.play_sfx("classic_jump")
		Global.instanceNodeAtPos(jump_particle, get_parent(), global_position + Vector2(0, 16))
		motion.y = -JUMP_FORCE
		jump_timer = 0
		ground_timer = 0
	
	set_velocity(motion)
	set_up_direction(UP)
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider: Object = collision.get_collider()
		if collider is TileMap:
			var pos: Vector2 = collider.local_to_map(collision.get_position() - collision.get_normal() - Vector2(1, 0))
			var cell: TileData = collider.get_cell_tile_data(0, pos)
			if cell != null:
				var type = cell.get_custom_data("type")
				#TODO: All types
				if type != null && type is int:
					var level: LevelPlayer = get_parent()
					match type:
						2:
							spawn_point = global_position
							level.set_spawnpoint(pos)
						3:
							die()
						4:
							finish_level()
						5:
							level.switch_color(true)
						6:
							level.switch_color(false)
	motion = velocity

func die():
	sound_effect_manager.play_rand_sfx(PlayerSoundEffect.Type.DIE)
	on_death.emit()
	global_position = spawn_point

func finish_level():
	if !LevelManager.current_level.is_empty():
		on_win.emit(timer.get_time())
