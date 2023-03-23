extends Node

const LEVELS = [
	[5],
	[7],
	[10],
	[12],
	[15],
	[17],
]

const LEVELS_DEFAULT: Array = [
	[99, 99, 99, true],
	[99, 99, 99, false],
	[99, 99, 99, false],
	[99, 99, 99, false],
	[99, 99, 99, false],
	[99, 99, 99, false]
]

var SAVE_LEVELS = LEVELS_DEFAULT

var currentLevel: int = 0

func merge_save_default():
	SAVE_LEVELS.resize(LEVELS_DEFAULT.size())
	for i in range(0, LEVELS_DEFAULT.size()):
		if SAVE_LEVELS[i].size() == LEVELS_DEFAULT[i].size():
			break;
		SAVE_LEVELS[i].resize(LEVELS_DEFAULT[i].size())
		if SAVE_LEVELS[i] == null:
			SAVE_LEVELS[i] = LEVELS_DEFAULT[i]
		for j in range(0, LEVELS_DEFAULT[i].size()):
			if SAVE_LEVELS[i][j] == null:
				SAVE_LEVELS[i][j] = LEVELS_DEFAULT[i][j]

func is_level_unlocked(id: int) -> bool:
	return get_save_level_property(id, 3)

func get_level_best_time(id: int) -> int:
	return int(str(get_save_level_property(id, 0)) + str(get_save_level_property(id, 1)) + str(get_save_level_property(id, 2)))

func get_level_best_time_str(id: int) -> Variant:
	var mins: int = get_save_level_property(id, 0)
	var secs: int = get_save_level_property(id, 1)
	var millis: int = get_save_level_property(id, 2)
	if mins == 99:
		mins = 0
	if secs == 99:
		secs = 0
	if millis == 99:
		millis = 0
	return str(mins).pad_zeros(2) + ":" + str(secs).pad_zeros(2) + ":" + str(millis).pad_zeros(2)

func set_level_best_time(mins: int, secs: int, millis: int) -> void:
	SAVE_LEVELS[currentLevel][0] = mins
	SAVE_LEVELS[currentLevel][1] = secs
	SAVE_LEVELS[currentLevel][2] = millis
	Global.saveGame()

func unlock_next_level() -> void:
	var id: int = currentLevel + 1
	if id <= LEVELS.size() && !is_level_unlocked(id):
		SAVE_LEVELS[id][3] = true
	Global.saveGame()

func get_number_of_coins(id: int) -> int:
	var sub: int = -1
	for i in range(0, SAVE_LEVELS.size()):
		if is_level_unlocked(i):
			sub += 1
	return max(0, get_level_property(id, 0) - sub)

func get_level_property(id: int, properity: int) -> Variant:
	return LEVELS[id][properity]

func get_save_level_property(id: int, properity: int) -> Variant:
	return SAVE_LEVELS[id][properity]
