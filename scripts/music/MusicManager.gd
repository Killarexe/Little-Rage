extends AudioStreamPlayer

const MUSIC_DIR_PATH: String = "res://assets/musics/"

var music_volume: float = 100.0
var sound_effect_volume: float = 100.0

func _ready() -> void:
	bus = "Music"
	process_mode = Node.PROCESS_MODE_ALWAYS

func set_music_volume(value: float) -> void:
	music_volume = value
	volume_db = music_volume / 4 - 25
	if value == 0.0:
		volume_db = -99
	SaveManager.save()

func play_music(music_id: String, from_position: float = 0.0) -> void:
	var music: AudioStream = load(MUSIC_DIR_PATH + music_id + ".ogg")
	if music != null:
		stop()
		stream = music
		play(from_position)
	else:
		print_rich("[color=red][b]Failed to play music: '" + music_id + "'[/b][/color]")
