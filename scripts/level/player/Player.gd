extends CharacterBody2D

const MAX_FALL_SPEED: float = 500.0
const GROUND_TIME: float = 0.2
const JUMP_FORCE: float = 350.0
const JUMP_TIME: float = 0.2
const MAX_SPEED: float = 200.0
const ACCEL: float = 7.5
const UP: Vector2 = Vector2(0, -1)
const G: float = 20.0

@onready var gui = $GUI
@onready var skin = $Sprite2D
@onready var camera = $Camera2D
@onready var win_menu = $GUI/WinMenu
@onready var pause_menu = $GUI/PauseMenu
@onready var audio = $AudioStreamPlayer2D
@onready var start_timer = $GUI/StartTimer
@onready var time_count_label = $GUI/TimeCount
@onready var death_count_label = $GUI/DeathCount
@onready var android_buttons = $GUI/AndroidButtons
@onready var jump_button = $GUI/AndroidButtons/JumpButton
@onready var left_button = $GUI/AndroidButtons/LeftButton
@onready var right_button = $GUI/AndroidButtons/RightButton
@onready var pause_button = $GUI/AndroidButtons/PauseButton
@onready var start_timer_animation = $GUI/StartTimer/AnimationPlayer

var prev_tile_id: Vector2i = Vector2i(-1, -1)
var max_y: int = 512 : set = set_max_y
var spawnPoint: Vector2 = Vector2()
var is_invinsible: bool = false
var enable_camera: bool = true
var is_power: bool = false
var motion: Vector2 = Vector2()
var groundTimer: float = 0
var jumpTimer: float = 0
var deathCount: int = 0

func start(title: bool):
	enable_camera = !title
	MusicPlayer.play_music(2)
	if !title:
		Global.ablePause()
	else:
		Global.unablePause()
	spawnPoint = global_position
	win_menu.visible = false
	android_buttons.visible = OS.get_name() == "Android"
	camera.enabled = enable_camera
	skin.texture = SkinManager.get_current_skin_texture()
	if !title:
		get_tree().paused = true
		start_timer.text = "3"
		start_timer_animation.play("count")
		await start_timer_animation.animation_finished
		start_timer.text = "2"
		start_timer_animation.play("count")
		await start_timer_animation.animation_finished
		start_timer.text = "1"
		start_timer_animation.play("count")
		await start_timer_animation.animation_finished
		get_tree().paused = false
	else:
		set_max_y(2048)
		spawnPoint = Vector2(205, 850)
		global_position = spawnPoint
		camera.queue_free()

func _process(_delta):
	if !enable_camera:
		gui.visible = false
	if(global_position.y >= max_y):
		die()
	if(global_position.y >= max_y - max_y / 2):
		if enable_camera:
			camera.position.y = -global_position.y + (max_y - max_y / 2)
	
	death_count_label.text = "Death Count: " + str(deathCount)
	
	#TODO: Do a better collision system
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider().name == "Map":
			var player_cell_position = floor(global_position / 16)
			var player_ground_full_position = floor((global_position + Vector2(0, 31)) / 16)
			var is_danger: Variant = (get_parent().get_tile_data("is_danger", player_cell_position + Vector2(0, 1)) ||
			get_parent().get_tile_data("is_danger", floor((global_position + Vector2(7, 1)) / 16)) ||
			get_parent().get_tile_data("is_danger", floor((global_position + Vector2(-7, 1)) / 16)))
			var is_door: Variant = (get_parent().get_tile_data("is_door", player_cell_position + Vector2(0, 1)) ||
			get_parent().get_tile_data("is_door", floor((global_position + Vector2(8, 0)) / 16)) ||
			get_parent().get_tile_data("is_door", floor((global_position + Vector2(-8, 0)) / 16)))
			var tile_ground: Vector2i = get_parent().get_tile_id(player_ground_full_position)
			
			if is_danger:
				die()
			elif is_door:
				finishLevel()
			
			if tile_ground == Global.CHECKPOINT_OFF_TILE:
				get_parent().replace_tile_by(Global.CHECKPOINT_ON_TILE, Global.CHECKPOINT_OFF_TILE)
				get_parent().change_tile(player_ground_full_position, Global.CHECKPOINT_ON_TILE)
				spawnPoint = (player_cell_position * 16) + Vector2(8, 0)
			elif tile_ground == Global.ON_TILE && prev_tile_id != Global.OFF_TILE && prev_tile_id != Global.ON_TILE:
				get_parent().turn_tiles(false)
			elif tile_ground == Global.OFF_TILE && prev_tile_id != Global.OFF_TILE && prev_tile_id != Global.ON_TILE:
				get_parent().turn_tiles(true)
			prev_tile_id = tile_ground

func _physics_process(delta):
	motion.y += G
	if(motion.y > MAX_FALL_SPEED):
		motion.y = MAX_SPEED
	playerController(delta)

func playerController(delta):
	jumpTimer -= delta
	groundTimer -= delta
	
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	
	if(Input.is_action_just_pressed("toggle_ui")):
		Overlay.visible = !Overlay.visible
		death_count_label.visible = Overlay.visible
		time_count_label.visible = Overlay.visible
	
	if(Input.is_action_pressed("left") or left_button.is_pressed()):
		motion.x -= ACCEL
		skin.flip_h = true
	elif(Input.is_action_pressed("right") or right_button.is_pressed()):
		motion.x += ACCEL
		skin.flip_h = false
	else:
		motion.x = lerpf(motion.x, 0, 0.2)
	
	if((Input.is_action_pressed("jump") or jump_button.is_pressed())):
		jumpTimer = JUMP_TIME
		
	if(jumpTimer > 0 and !(Input.is_action_pressed("jump") or jump_button.is_pressed())):
		jumpTimer = 0
		if(motion.y < 0):
			motion.y = motion.y * 0.5
	
	if(is_power):
		Global.instanceNodeAtPos(load("res://scenes/prefabs/JumpParticle.tscn"), get_parent(), global_position + Vector2(0, 16))
	
	if(is_on_floor()):
		if groundTimer < 0:
			if enable_camera:
				camera.position.y = 0
			is_invinsible = false
			Global.instanceNodeAtPos(load("res://scenes/prefabs/JumpParticle.tscn"), get_parent(), global_position + Vector2(0, 16))
		groundTimer = GROUND_TIME
	
	if((jumpTimer > 0) and (groundTimer > 0)):
		audio.playSFX(0)
		Global.instanceNodeAtPos(load("res://scenes/prefabs/JumpParticle.tscn"), get_parent(), global_position + Vector2(0, 16))
		motion.y = -JUMP_FORCE
		if(is_power):
			motion.y += -JUMP_FORCE
		jumpTimer = 0
		groundTimer = 0
	
	set_velocity(motion)
	set_up_direction(UP)
	move_and_slide()
	motion = velocity

func finishLevel():
	audio.playSFX(3)
	pause_menu.set_paused(false)
	Global.unablePause()
	get_tree().paused = true
	win_menu.start(self, time_count_label)

func die():
	if is_invinsible:
		pass
	is_invinsible = true
	audio.playSFX(1)
	deathCount += 1
	Global.instanceNodeAtPos(load("res://scenes/prefabs/PoofParticle.tscn"), get_parent(), global_position + Vector2(0, 0))
	global_position = spawnPoint
	Global.instanceNodeAtPos(load("res://scenes/prefabs/PoofParticle.tscn"), get_parent(), global_position + Vector2(0, 0))

func set_max_y(value: int):
	max_y = value

func _on_PauseButton_pressed():
	audio.playSFX(4)
	pause_menu.set_paused(!pause_menu.is_paused)
