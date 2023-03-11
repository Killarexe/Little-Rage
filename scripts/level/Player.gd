extends CharacterBody2D

const MAX_FALL_SPEED: float = 500.0
const GROUND_TIME: float = 0.2
const JUMP_FORCE: float = 350.0
const JUMP_TIME: float = 0.2
const MAX_SPEED: float = 200.0
const ACCEL: float = 7.5
const UP: Vector2 = Vector2(0, -1)
const G: float = 20.0

var SFXS = [
	load("res://sounds/sfx/jump.wav"),
	load("res://sounds/sfx/die.wav"),
	load("res://sounds/sfx/die2.wav"),
	load("res://sounds/sfx/finish.wav"),
	load("res://sounds/sfx/select.wav"),
]

@onready var audio = $AudioStreamPlayer2D

var max_y: int = 512 : set = set_max_y
var spawnPoint: Vector2 = Vector2()
var is_invinsible: bool = false
var enable_camera: bool = true
var is_power: bool = false
var motion: Vector2 = Vector2()
var timer_milliseconds: int = 0
var timer_minutes: int = 0
var timer_seconds: int = 0
var groundTimer: float = 0
var jumpTimer: float = 0
var deathCount: int = 0

func _ready():
	Global.play_music(2)
	Global.ablePause()
	spawnPoint = global_position
	$GUI/WinMenu.visible = false
	if(OS.get_name() != "Android"):
		$GUI/PauseButton.visible = false
		$GUI/LeftButton.visible = false
		$GUI/RightButton.visible = false
		$GUI/JumpButton.visible = false
	$Camera2D.enabled = enable_camera
	$Sprite2D.texture = Global.skins[Global.currentSkin][0]

func _process(delta):
	if !enable_camera:
		$GUI.visible = false
	if(global_position.y >= max_y):
		die()
	if(global_position.y >= max_y - max_y / 2):
		if enable_camera:
			$Camera2D.position.y = -global_position.y + (max_y - max_y / 2)
	
	$GUI/DeathCount.text = "Death Count: " + str(deathCount)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var node = collision.get_collider()
		if node.name == "Map":
			var player_cell_position = floor(global_position / 16)
			var player_ground_position = player_cell_position + Vector2(0, 1)
			var player_front_position = floor((global_position + Vector2(8, 0)) / 16)
			var player_top_position = floor((global_position - Vector2(0, 31)) / 16)
			if get_parent().get_tile_data("is_danger", player_ground_position) == true:
				die()
			elif get_parent().get_tile_data("is_door", player_ground_position) == true:
				finishLevel()
			if get_parent().get_tile_data("is_door", player_front_position) == true:
				finishLevel()
			if get_parent().get_tile_id(player_top_position) == Global.ON_TILE:
				get_parent().replace_tile_by(Global.ON_TILE, Global.OFF_TILE)
				get_parent().replace_tile_by(Global.BLUE_EMPTY_TILE, Global.BLUE_FULL_TILE)
				get_parent().replace_tile_by(Global.RED_FULL_TILE, Global.RED_EMPTY_TILE)
			elif get_parent().get_tile_id(player_top_position) == Global.OFF_TILE:
				get_parent().replace_tile_by(Global.OFF_TILE, Global.ON_TILE)
				get_parent().replace_tile_by(Global.RED_EMPTY_TILE, Global.RED_FULL_TILE)
				get_parent().replace_tile_by(Global.BLUE_FULL_TILE, Global.BLUE_EMPTY_TILE)

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
		$GUI/DeathCount.visible = Overlay.visible
		$GUI/TimeCount.visible = Overlay.visible
	
	if(Input.is_action_pressed("left") or $GUI/LeftButton.is_pressed()):
		motion.x -= ACCEL
		$Sprite2D.flip_h = true
	elif(Input.is_action_pressed("right") or $GUI/RightButton.is_pressed()):
		motion.x += ACCEL
		$Sprite2D.flip_h = false
	else:
		motion.x = lerpf(motion.x, 0, 0.2)
	
	if((Input.is_action_pressed("jump") or $GUI/JumpButton.is_pressed())):
		jumpTimer = JUMP_TIME
		
	if(jumpTimer > 0 and !(Input.is_action_pressed("jump") or $GUI/JumpButton.is_pressed())):
		jumpTimer = 0
		if(motion.y < 0):
			motion.y = motion.y * 0.5
	
	if(is_power):
		Global.instanceNodeAtPos(load("res://scenes/prefabs/JumpParticle.tscn"), get_parent(), global_position + Vector2(0, 16))
	
	if(is_on_floor()):
		if groundTimer < 0:
			if enable_camera:
				$Camera2D.position.y = 0
			is_invinsible = false
			Global.instanceNodeAtPos(load("res://scenes/prefabs/JumpParticle.tscn"), get_parent(), global_position + Vector2(0, 16))
		groundTimer = GROUND_TIME
	
	if((jumpTimer > 0) and (groundTimer > 0)):
		playSFX(0)
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
	playSFX(3)
	$GUI/PauseMenu.set_paused(false)
	Global.unablePause()
	get_tree().paused = true
	$GUI/WinMenu.start(self)

func die():
	if is_invinsible:
		pass
	is_invinsible = true
	playSFX(1)
	deathCount += 1
	Global.instanceNodeAtPos(load("res://scenes/prefabs/PoofParticle.tscn"), get_parent(), global_position + Vector2(0, 0))
	global_position = spawnPoint
	Global.instanceNodeAtPos(load("res://scenes/prefabs/PoofParticle.tscn"), get_parent(), global_position + Vector2(0, 0))

func playSFX(index: int):
	if audio.playing:
		audio.stop()
	audio.pitch_scale = randf()*1+0.5
	audio.stream = SFXS[index]
	audio.play()

func set_max_y(value: int):
	max_y = value

func _on_PauseButton_pressed():
	playSFX(4)
	$GUI/PauseMenu.set_paused(!$GUI/PauseMenu.is_paused)

func update_timer():
	if timer_milliseconds > 59:
		timer_seconds += 1
		timer_milliseconds = 0
	if timer_seconds > 59:
		timer_minutes += 1
		timer_seconds = 0
	$GUI/TimeCount.text = "Time: " + str(timer_minutes).pad_zeros(2) + ":" + str(timer_seconds).pad_zeros(2) + ":" +str(timer_milliseconds).pad_zeros(2)

func _on_Timer_timeout():
	timer_milliseconds += 1;
	update_timer();
