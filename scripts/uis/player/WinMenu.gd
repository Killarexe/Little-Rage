extends CanvasLayer
class_name WinMenu

enum Mode{
	SINGLEPLAYER,
	MULTIPLAYER
}

@export var player: PlayerMovement
@onready var singleplayer: Control = $Singleplayer
@onready var multiplayer_control: Control = $Mutiplayer
@onready var time_label: TimeLabel = $Singleplayer/VBoxContainer/TimeLabel
@onready var best_time_animation: AnimationPlayer = $Singleplayer/AnimationPlayer
@onready var next_level_button: Button = $Singleplayer/VBoxContainer/NextLevel

var mode: Mode = Mode.SINGLEPLAYER

func _ready():
	singleplayer.visible = false
	multiplayer_control.visible = false
	player.on_win.connect(on_player_win)

func on_player_win(time: Array[int], death_count: int):
	open(Mode.SINGLEPLAYER, time, death_count)

func open(playing_mode: Mode, time: Array[int], death_count: int):
	MusicManager.stop()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if PlayerSkinManager.current_skin == "mexican_player" && PlayerHatManager.current_hat == "mexican_hat":
		mexican_mode()
	get_tree().paused = true
	Game.can_pause = false
	var time_sum: int = 0
	for i in time:
		time_sum += i
	match playing_mode:
		Mode.SINGLEPLAYER:
			singleplayer.visible = true
			var is_best_time: bool = LevelManager.is_best_time(time)
			time_label.start(time, death_count)
			next_level_button.visible = LevelManager.is_default_level(LevelManager.current_level)
			if is_best_time:
				if LevelManager.get_level_best_time(LevelManager.current_level) != [0, 0, 0]:
					LootBoxesManager.add_loot_box(0, true)
					best_time_animation.play("pop_besttime")
				else:
					LootBoxesManager.add_loot_box((time_sum * time_sum) / pow(3 * 99, 2))
				LevelManager.set_level_best_time(time)
			else:
				LootBoxesManager.add_loot_box((time_sum * time_sum) / pow(3 * 99, 2))
		Mode.MULTIPLAYER:
			multiplayer_control.visible = true

func mexican_mode():
	MusicManager.play_music("mexican_music")
	Game.instanceNodeAtPos(load("res://scenes/instances/level/tacosParticle.tscn"), self, Vector2(0, -100))

func exit():
	Game.can_pause = true
	match mode:
		Mode.SINGLEPLAYER:
			SaveManager.save_game()
			SceneManager.change_scene("res://scenes/uis/SoloMenu.tscn")
		Mode.MULTIPLAYER:
			#TODO: Return to lobby
			SaveManager.save_game()
			SceneManager.change_scene("res://scenes/uis/SoloMenu.tscn")
			pass

func _on_next_level_pressed():
	var current_level_number: int = int(LevelManager.current_level.replace("level_", ""))
	if current_level_number == LevelManager.default_levels.size():
		SceneManager.change_scene("res://scenes/levels/CreditsScene.tscn")
	else:
		var current_level: String = "level_" + str(current_level_number + 1)
		var level: Level = LevelManager.get_level(current_level)
		LevelManager.current_level = current_level
		MusicManager.play_music("level_plains")
		SceneManager.change_packed(level.scene)
