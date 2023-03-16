extends AudioStreamPlayer

var musics = [
	load("res://sounds/musics/level_select.mp3"),
	load("res://sounds/musics/nofall.wav"),
	load("res://sounds/musics/level_one.mp3"),
	load("res://sounds/musics/shop.mp3"),
	load("res://sounds/musics/easter.mp3"),
]

func play_music(id: int):
	stop()
	stream = musics[id];
	play()
