extends Node

var LEVELS = {
	0: [99, 99, 99, true],
	1: [99, 99, 99, false],
	2: [99, 99, 99, false],
	3: [99, 99, 99, false],
	4: [99, 99, 99, false],
	5: [99, 99, 99, false],
}

var currentLevel: int = 0

func is_level_unlocked(id: int) -> bool:
	return LEVELS[str(id)][3]

func get_level_best_time(id: int) -> int:
	var level: Array = LEVELS[str(id)]
	return int(str(level[0]) + str(level[1]) + str(level[2]))

func get_level_best_time_str(id: int) -> Variant:
	var level: Array = LEVELS[str(id)]
	var mins: int = level[0]
	var secs: int = level[1]
	var millis: int = level[2]
	if mins == 99:
		mins = 0
	if secs == 99:
		secs = 0
	if millis == 99:
		millis = 0
	return str(mins).pad_zeros(2) + ":" + str(secs).pad_zeros(2) + ":" + str(millis).pad_zeros(2)

func set_level_best_time(mins: int, secs: int, millis: int) -> void:
	var level: Array = LEVELS[str(currentLevel)]
	level[0] = mins
	level[1] = secs
	level[2] = millis

func unlock_next_level() -> void:
	var id: int = currentLevel + 1
	if id <= LEVELS.size():
		LEVELS[str(id)][3] = true
