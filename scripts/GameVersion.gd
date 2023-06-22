extends Node
class_name GameVersion

var upper: int = 0
var middle: int = 0
var down: int = 0

enum GameVersionCompare{
	LOWER,
	SAME,
	HIGHER
}

static func from_array(array: Array[int]) -> GameVersion:
	if array.size() < 3:
		return Global.GAME_VERSION
	return from(array[0], array[1], array[2])

static func from(upper_: int, middle_: int, down_: int) -> GameVersion:
	var version = GameVersion.new()
	version.upper = upper_
	version.middle = middle_
	version.down = down_
	return version

func as_int():
	return down + (middle << 4) + (upper << 8)

func compare(version: GameVersion) -> GameVersionCompare:
	var current_version: int = as_int()
	var version_cmp: int = version.as_int()
	if version_cmp > current_version:
		return GameVersionCompare.HIGHER
	if version_cmp < current_version:
		return GameVersionCompare.LOWER
	return GameVersionCompare.SAME
