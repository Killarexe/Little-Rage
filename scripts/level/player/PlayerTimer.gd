extends Timer
class_name PlayerTimer

var milliseconds: int = 0
var secondes: int = 0
var minutes: int = 0

func _ready():
	connect("timeout", on_timeout)

func on_timeout():
	milliseconds += 5
	if milliseconds >= 100:
		secondes += 1
		milliseconds = 0
		if secondes >= 60:
			minutes += 1
			secondes = 0

func get_time() -> Array[int]:
	return [minutes, secondes, milliseconds]
