extends AudioStreamPlayer2D

var SFXS = [
	load("res://sounds/sfx/jump.wav"),
	load("res://sounds/sfx/die.wav"),
	load("res://sounds/sfx/die2.wav"),
	load("res://sounds/sfx/finish.wav"),
	load("res://sounds/sfx/select.wav"),
]

func playSFX(index: int):
	if playing:
		stop()
	pitch_scale = randf()*1+0.5
	stream = SFXS[index]
	play()
