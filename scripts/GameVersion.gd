extends Node
class_name GameVersion

var upper: int = 0
var middle: int = 0
var down: int = 0

static func from(upper: int, middle: int, down: int) -> GameVersion:
	var version = GameVersion.new()
	version.upper = upper
	version.middle = middle
	version.down = down 
	return version
