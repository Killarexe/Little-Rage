extends Node
class_name GameVersion

var upper: int = 0
var middle: int = 0
var down: int = 0

enum GameVersionFlag{
	LOWER,
	SAME,
	HIGHER
}

static func from_string(value: String) -> GameVersion:
	var regex = RegEx.new()
	regex.compile("[^0-9.]")
	var version_array: PackedStringArray = regex.sub(value, "").split(".")
	if version_array.size() < 3:
		return null
	return from(int(version_array[0]), int(version_array[1]), int(version_array[2]))

static func from(upper_: int, middle_: int, down_: int) -> GameVersion:
	var version = GameVersion.new()
	version.upper = upper_
	version.middle = middle_
	version.down = down_
	return version

func as_int() -> int:
	return down + (middle << 4) + (upper << 8)

func as_str() -> String:
	return str(upper) + "." + str(middle) + "." + str(down)

func compare(version: GameVersion) -> GameVersionFlag:
	if version == null:
		return GameVersionFlag.SAME
	var current_version: int = as_int()
	var version_cmp: int = version.as_int()
	if version_cmp > current_version:
		return GameVersionFlag.HIGHER
	if version_cmp < current_version:
		return GameVersionFlag.LOWER
	return GameVersionFlag.SAME
