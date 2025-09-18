extends CanvasLayer
class_name WinMenu

@export var player: PlayerComponent
@export var player_status_ui: PlayerStatus

@onready var singleplayer: Control = $Singleplayer
@onready var time_label: TimeLabel = $Singleplayer/VBoxContainer/TimeLabel
@onready var best_time_animation: AnimationPlayer = $Singleplayer/AnimationPlayer
@onready var next_level_button: Button = $Singleplayer/VBoxContainer/NextLevel

func _ready():
  singleplayer.visible = false
  player.on_win.connect(on_player_win)

func on_player_win(time: Array[int], death_count: int):
  open(time, death_count)

func open(time: Array[int], death_count: int):
  MusicManager.stop()
  Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
  if PlayerSkinManager.current_skin == "mexican_player" && PlayerHatManager.current_hat == "mexican_hat":
    mexican_mode()
  get_tree().paused = true
  Game.can_pause = false
  var time_sum: int = 0
  for i in time:
    time_sum += i
  player_status_ui.visible = false
  singleplayer.visible = true
  
  var is_best_time: bool = LevelManager.is_best_time(time)
  var level_theme: Level.LevelTheme = LevelManager.get_current_level().level_theme
  var music_id: String = "level_win_" + Level.level_theme_to_str(level_theme)
  if is_best_time:
    music_id += "_variant"
  MusicManager.play_music(music_id)
  
  if LevelManager.is_default_level(LevelManager.current_level):
    var current_level_number: int = int(LevelManager.current_level.replace("level_", ""))
    if current_level_number == LevelManager.default_levels.size():
      next_level_button.text = TranslationServer.translate("button.credits_scene")
    next_level_button.visible = true
  else:
    next_level_button.visible = false
  
  best_time_animation.play("intro")
  time_label.start(time, death_count)
  await best_time_animation.animation_finished
  
  if is_best_time:
    if LevelManager.get_level_best_time(LevelManager.current_level) != [0, 0, 0]:
      LootBoxesManager.add_loot_box(0, true)
      best_time_animation.play("pop_besttime")
    else:
      LootBoxesManager.add_loot_box((time_sum * time_sum) / pow(3 * 99, 2))
    LevelManager.set_level_best_time(time)
  else:
    LootBoxesManager.add_loot_box((time_sum * time_sum) / pow(3 * 99, 2))

func mexican_mode():
  MusicManager.play_music("mexican_music")
  Game.instanceNodeAtPos(load("res://scenes/bundles/particles/tacosParticle.tscn"), self, Vector2(0, -100))

func exit():
  LevelManager.current_level = ""
  Game.can_pause = true
  SaveManager.save()
  SceneManager.change_scene("res://scenes/uis/SoloMenu.tscn")

func _on_next_level_pressed():
  var current_level_number: int = int(LevelManager.current_level.replace("level_", ""))
  if current_level_number == LevelManager.default_levels.size():
    SceneManager.change_scene("res://scenes/levels/CreditsScene.tscn")
  else:
    var current_level: String = "level_" + str(current_level_number + 1)
    var level: Level = LevelManager.get_level(current_level)
    LevelManager.current_level = current_level
    SceneManager.change_packed(level.scene)

func _on_replay_button_pressed():
  SceneManager.change_packed(LevelManager.get_current_level().scene)
