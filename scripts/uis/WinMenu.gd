extends Control
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

func open(mode: Mode):
	MusicManager.play_music("level_win")
	match mode:
		Mode.SINGLEPLAYER:
			singleplayer.visible = true
		Mode.MULTIPLAYER:
			multiplayer_control.visible = true

func exit():
	match mode:
		Mode.SINGLEPLAYER:
			pass
		Mode.MULTIPLAYER:
			#Return to lobby
			pass
