extends Node2D

@export var player: PlayerComponent
@export var player_camera: Camera2D
@export var player_menus: PlayerMenus
@onready var animation_camera: Camera2D = $Camera2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var countdown_prefab: Resource = load("res://scenes/instances/level/player/uis/countdown.tscn")

func _ready():
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
	Game.can_pause = false
	get_tree().paused = true
	animation_player.play("entry")
	var music_id: String = "start_level_var1"
	if LevelManager.get_level_best_time(LevelManager.current_level) == [0, 0, 0]:
		music_id = "start_level"
	elif PlayerHatManager.has_unlocked_unhiddens() && PlayerSkinManager.has_unlocked_unhiddens():
		music_id = "start_level_var2"
	MusicManager.play_music(music_id)
	await MusicManager.finished
	player_camera.enabled = true
	animation_camera.enabled = false
	Game.instanceNode(countdown_prefab, player)
	queue_free()

func enable_status():
	player_menus.player_status.visible = !LevelManager.current_level.is_empty()
	player_menus.mobile_control.visible = Game.is_mobile
