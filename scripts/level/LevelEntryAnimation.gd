extends Node2D

@export var player: PlayerMovement
@export var player_camera: Camera2D
@export var player_menus: PlayerMenus
@onready var animation_camera: Camera2D = $Camera2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var countdown_prefab: Resource = load("res://scenes/instances/level/player/uis/countdown.tscn")

func _ready():
	if visible && player.camera_enabled && player.controllable:
		if LevelManager.current_level.is_empty():
			enable_status()
		else:
			play_animation()

func play_animation():
	await player.ready
	player_menus.player_status.visible = false
	player_menus.mobile_control.visible = false
	animation_camera.enabled = true
	player_camera.enabled = false
	Global.can_pause = false
	get_tree().paused = true
	animation_player.play("entry")
	MusicManager.play_music("start_level_var1")
	await MusicManager.finished
	player_camera.enabled = true
	animation_camera.enabled = false
	Global.instanceNode(countdown_prefab, player)
	queue_free()

func enable_status():
	player_menus.player_status.visible = !LevelManager.current_level.is_empty()
	player_menus.mobile_control.visible = Global.is_mobile