extends Node

const LEVELS_DEFAULT = {
	0: [99, 99, 99, 5, true],
	1: [99, 99, 99, 7, false],
	2: [99, 99, 99, 10, false],
	3: [99, 99, 99, 12, false],
	4: [99, 99, 99, 15, false],
	5: [99, 99, 99, 17, false],
}

var LEVELS = LEVELS_DEFAULT

var currentLevel: int = 0

func is_level_unlocked(id: int) -> bool:
	return LEVELS[str(id)][4]

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
	if id <= LEVELS.size() && !LEVELS[str(id)][4]:
		LEVELS[str(id)][4] = true

func get_number_of_coins(id: int) -> int:
	var sub: int = 0
	for i in LEVELS:
		if LEVELS[str(i)][4]:
			sub += 1
	return max(0, LEVELS[str(id)][3] - sub)
