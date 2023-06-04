extends AudioStreamPlayer

const MUSIC_DIR_PATH: String = "res://data/musics"

var musics: Array[Music] = []

var volume: float = 100.0

func _ready():
	bus = "Music"
	var resources: Array[ResourceElement] = DataLoader.new().load_data_in_dir(MUSIC_DIR_PATH, "music")
	for resource in resources:
		if resource is Music:
			musics.append(resource)

func get_music(music_id: String) -> Music:
	for music in musics:
		if music.id == music_id:
			return music
	return null

func play_rand_music(type: Music.Type):
	var musics_type: Array[Music] = musics.duplicate().map(func(m): if m.type == type: return m)
	var index: int = randi_range(0, musics_type.size() - 1)
	stop()
	stream = musics_type[index].stream
	play()

func play_music(music_id: String):
	var music: Music = get_music(music_id)
	if music != null:
		stop()
		stream = music.stream
		play()
