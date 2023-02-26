extends KinematicBody2D

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

onready var audio = $AudioStreamPlayer2D

var max_y: int = 512 setget set_max_y
var spawnPoint: Vector2 = Vector2()
var is_invinsible: bool = false
var enable_camera: bool = true
var is_power: bool = false
var motion: Vector2 = Vector2()
var groundTimer: float = 0
var jumpTimer: float = 0
var deathCount: int = 0
var timer: int = 0

func _ready():
	Global.play_music(2)
	Global.ablePause()
	spawnPoint = global_position
	$GUI/LoseMenu.visible = false
	$GUI/WinMenu.visible = false
	if(OS.get_name() != "Android"):
		$GUI/PauseButton.visible = false
		$GUI/LeftButton.visible = false
		$GUI/RightButton.visible = false
		$GUI/JumpButton.visible = false
	$Camera2D.current = enable_camera
	$Sprite.texture = Global.currentSkin[0]

func _process(delta):
	if !enable_camera:
		$GUI.visible = false
	if(global_position.y >= max_y):
		die()
	if(global_position.y >= max_y - max_y / 2):
		if enable_camera:
			$Camera2D.current = false
	$GUI/DeathCount.text = "Death Count: " + str(deathCount)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if(collision.collider.name == "Finish"):
			finishLevel()
			break
		if(collision.collider.name == "Deadly"):
			die()
			break

func _physics_process(delta):
	motion.y += G
	if(motion.y > MAX_FALL_SPEED):
		motion.y = MAX_SPEED
	playerController(delta)

func playerController(delta):
	jumpTimer -= delta
	groundTimer -= delta
	
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	
	if(Input.is_action_pressed("ui_left") or $GUI/LeftButton.is_pressed()):
		motion.x -= ACCEL
		$Sprite.flip_h = true
	elif(Input.is_action_pressed("ui_right") or $GUI/RightButton.is_pressed()):
		motion.x += ACCEL
		$Sprite.flip_h = false
	else:
		motion.x = lerp(motion.x, 0, 0.2)
	
	if((Input.is_action_pressed("ui_up") or $GUI/JumpButton.is_pressed())):
		jumpTimer = JUMP_TIME
		
	if(jumpTimer > 0 and !(Input.is_action_pressed("ui_up") or $GUI/JumpButton.is_pressed())):
		jumpTimer = 0
		if(motion.y < 0):
			motion.y = motion.y * 0.5
	
	if(is_power):
		Global.instanceNodeAtPos(load("res://scenes/prefabs/JumpParticle.tscn"), get_parent(), global_position + Vector2(0, 16))
	
	if(is_on_floor()):
		if groundTimer < 0:
			if enable_camera:
				$Camera2D.current = true
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
	
	motion = move_and_slide(motion, UP)

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
