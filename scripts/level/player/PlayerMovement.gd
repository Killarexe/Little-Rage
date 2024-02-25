extends CharacterBody2D
class_name PlayerMovement

@export var controllable: bool = true
@export var can_pause: bool = true
@export var interactable: bool = true
@export var camera_enabled: bool = true
@export var override_skin: String = ""
@export var override_hat: String = ""
@export var motion: Vector2 = Vector2.ZERO

@onready var timer: PlayerTimer = $Timer
@onready var skin: PlayerSkinSprite = $Skin
@onready var player_controller: PlayerControllerComponent = $PlayerControllerComponent

signal on_setting_spawnpoint(pos: Vector2)
signal on_switch_color(color: bool)
signal on_win(time: Array[int], death_count: int)
signal on_death(death_count: int)

var death_count: int = 0
var y_limit: int = Level.DEFAULT_Y_LIMIT
var spawn_point: Vector2 = Vector2()

func _ready():
	Game.can_pause = can_pause
	if !override_skin.is_empty():
		skin.texture = PlayerSkinManager.get_skin(override_skin).texture
	if !override_hat.is_empty():
		skin.hat_sprite.texture = PlayerHatManager.get_hat(override_hat).texture

func _process(_delta: float) -> void:
	if motion.length() != 0:
		print("override")
		player_controller.velocity.motion.x = motion.x / 2

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
	player_controller.jump_timer = player_controller.JUMP_TIME

func end_jump():
	player_controller.jump_timer = 0
