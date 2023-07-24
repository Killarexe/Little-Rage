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
	get_tree().paused = true
	Global.can_pause = false
	var time_sum: int = 0
	for i in time:
		time_sum += i
	Global.loot_boxes.add_loot_box(int(time_sum / 3.0 * 99.0))
	match mode_:
		Mode.SINGLEPLAYER:
			singleplayer.visible = true
			var is_best_time: bool = LevelManager.is_best_time(time)
			time_label.start(time, death_count, is_best_time)
			if is_best_time:
				LevelManager.set_level_best_time(time)
		Mode.MULTIPLAYER:
			multiplayer_control.visible = true

func exit():
	Global.can_pause = true
	match mode:
		Mode.SINGLEPLAYER:
			Global.save_game()
			SceneManager.change_scene("res://scenes/uis/LevelSelector.tscn")
		Mode.MULTIPLAYER:
			#Return to lobby
			pass
