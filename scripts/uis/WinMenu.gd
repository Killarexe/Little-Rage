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

func on_player_win():
	open(Mode.SINGLEPLAYER)

func open(mode_: Mode):
	MusicManager.play_music("level_win")
	get_tree().paused = true
	Global.can_pause = false
	match mode_:
		Mode.SINGLEPLAYER:
			singleplayer.visible = true
		Mode.MULTIPLAYER:
			multiplayer_control.visible = true

func exit():
	Global.can_pause = true
	match mode:
		Mode.SINGLEPLAYER:
			SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")
		Mode.MULTIPLAYER:
			#Return to lobby
			pass
