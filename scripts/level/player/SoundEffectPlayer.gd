extends AudioStreamPlayer2D
class_name SoundEffectPlayer

const SFX_DIR_PATH: String = "res://data/sound_effects"

var sfxs: Array[PlayerSoundEffect] = []

var sfx_volume: float = 100.0

func _ready():
	bus = "Sound Effects"
	process_mode = Node.PROCESS_MODE_ALWAYS
	var resources: Array[ResourceElement] = DataLoader.new().load_data_in_dir(SFX_DIR_PATH, "player_sound_effect")
	for resource in resources:
		if resource is PlayerSoundEffect:
			sfxs.append(resource)
	set_sfx_volume(MusicManager.sound_effect_volume)

func set_sfx_volume(value: float):
	sfx_volume = value
	volume_db = min(max(sfx_volume - 50, -30), 0)

func get_sfx(sfx_id: String) -> PlayerSoundEffect:
	for sfx in sfxs:
		if sfx.id == sfx_id:
			return sfx
	return null

func play_rand_sfx(type: PlayerSoundEffect.Type):
	var sfxs_type: Array = sfxs.map(func(m): if m.type == type: return m)
	if sfxs_type[0] == null:
		print("Failed to play random sfx typed: " + str(type))
		return
	var index: int = randi_range(0, sfxs_type.size() - 1)
	stop()
	pitch_scale = randf()*1+sfxs_type[index].pitch_max_offset
	stream = sfxs_type[index].stream
	play()

func play_sfx(sfx_id: String):
	var sfx: PlayerSoundEffect = get_sfx(sfx_id)
	if sfx != null:
		stop()
		pitch_scale = randf()*1+sfx.pitch_max_offset
		stream = sfx.stream
		play()
	else:
		print("Failed to play sfx: '" + sfx_id + "'")
