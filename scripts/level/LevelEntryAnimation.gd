extends Node2D

@export var player: PlayerComponent
@export var player_camera: Camera2D
@export var player_menus: PlayerMenus
@export var skip_control: TouchScreenButton

@onready var animation_camera: Camera2D = $Camera2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var countdown_prefab: Resource = load("res://scenes/bundles/uis/countdown.tscn")

func _ready() -> void:
  await player_menus.ready
  if LevelManager.current_level.is_empty():
    enable_status()
  else:
    play_animation()

func _input(event: InputEvent) -> void:
  if event.is_action_pressed("pause") && animation_player.is_playing():
    skip()

func skip():
  animation_player.stop()
  MusicManager.stop()
  animation_player.animation_finished.emit()
  enable_status()

func play_animation() -> void:
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
  await animation_player.animation_finished
  player_camera.enabled = true
  animation_camera.enabled = false
  Game.instanceNode(countdown_prefab, player)
  queue_free()

func enable_status() -> void:
  if Game.is_mobile:
    skip_control.queue_free()
  player_menus.player_status.visible = !LevelManager.current_level.is_empty()
  player_menus.mobile_control.visible = Game.is_mobile
