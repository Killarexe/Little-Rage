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

var mode: Mode = Mode.SINGLEPLAYER

func _ready():
	singleplayer.visible = false
	multiplayer_control.visible = false
	player.on_win.connect(on_player_win)

func on_player_win(time: Array[int], death_count: int):
	open(Mode.SINGLEPLAYER, time, death_count)

func open(mode_: Mode, time: Array[int], death_count: int):
	MusicManager.stop()
	if PlayerSkinManager.current_skin == "mexican_player" && PlayerHatManager.current_hat == "mexican_hat":
		mexican_mode()
	get_tree().paused = true
	Global.can_pause = false
	var time_sum: int = 0
	for i in time:
		time_sum += i
	match mode_:
		Mode.SINGLEPLAYER:
			singleplayer.visible = true
			var is_best_time: bool = LevelManager.is_best_time(time)
			time_label.start(time, death_count, is_best_time)
			if is_best_time:
				LevelManager.set_level_best_time(time)
				Global.loot_boxes.add_loot_box(1)
			else:
				Global.loot_boxes.add_loot_box(1.0 / time_sum / 3.0 * 99.0)
		Mode.MULTIPLAYER:
			multiplayer_control.visible = true

func mexican_mode():
	MusicManager.play_music("mexican_music")
	Global.instanceNodeAtPos(load("res://scenes/instances/level/tacosParticle.tscn"), self, Vector2(0, -100))

func exit():
	Global.can_pause = true
	match mode:
		Mode.SINGLEPLAYER:
			Global.save_game()
			SceneManager.change_scene("res://scenes/uis/LevelSelector.tscn")
		Mode.MULTIPLAYER:
			#Return to lobby
			pass
