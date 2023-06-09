extends Node
class_name GameVersion

var upper: int = 0
var middle: int = 0
var down: int = 0

static func from(upper_: int, middle_: int, down_: int) -> GameVersion:
	var version = GameVersion.new()
	version.upper = upper_
	version.middle = middle_
	version.down = down_
	return version
