extends AudioStreamPlayer2D
class_name SoundEffectPlayer

const SFX_DIR_PATH: String = "res://assets/sound_effects/"

var sfx_volume: float = 50.0

func _ready():
	bus = "Sound Effect"
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_sfx_volume(MusicManager.sound_effect_volume)

func set_sfx_volume(value: float):
	sfx_volume = value
	volume_db = min(max(sfx_volume - 50, -30), 0)

func play_sfx(sfx_id: String, pitch_range: float = 0.5):
	var sfx: AudioStream = load(SFX_DIR_PATH + sfx_id + ".ogg")
	if sfx != null:
		stop()
		pitch_scale = randf() * 1 + pitch_range
		stream = sfx
		play()
	else:
		print_rich("[color=red][b]Failed to play sfx: '" + sfx_id + "'[/b][/color]")
