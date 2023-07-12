extends CanvasLayer
class_name WinMenu

enum Mode{
	SINGLEPLAYER,
	MULTIPLAYER
}

@export var player: PlayerMovement
@onready var singleplayer: Control = $Singleplayer
@onready var multiplayer_control: Control = $Mutiplayer

var mode: Mode = Mode.SINGLEPLAYER

func _ready():
	singleplayer.visible = false
	multiplayer_control.visible = false
	player.on_win.connect(on_player_win)

func on_player_win(time: Array[int]):
	open(Mode.SINGLEPLAYER, time)

func open(mode_: Mode, time: Array[int]):
	MusicManager.play_music("level_win")
	get_tree().paused = true
	Global.can_pause = false
	Global.loot_boxes.add_loot_box(1.0/time.max())
	match mode_:
		Mode.SINGLEPLAYER:
			singleplayer.visible = true
			$Singleplayer/TimeLabel.text = str(time)
			if LevelManager.is_best_time(time):
				LevelManager.set_level_best_time(time)
				$Singleplayer/TimeLabel.text += " Best Time!"
		Mode.MULTIPLAYER:
			multiplayer_control.visible = true

func exit():
	Global.can_pause = true
	match mode:
		Mode.SINGLEPLAYER:
			Global.save_game()
			SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")
		Mode.MULTIPLAYER:
			#Return to lobby
			pass
