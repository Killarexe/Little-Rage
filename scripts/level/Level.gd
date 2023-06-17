extends ResourceElement
class_name Level

enum Mode{
	RACE,	#Classic singleplayer
	BATTLE	#Classic multiplayer
}

enum Difficulty{
	BEGINER_FRIENDLY,
	EASY,
	NORMAL,
	HARD,
	EXTREME
}

const DEFAULT_NAME: String = "MyLevel"
const DEFAULT_Y_LIMIT: int = 512
const DEFAULT_MODE: Mode = Mode.RACE
const DEFAULT_DESCRIPTION: String = "Hello, world!"
const DEFAULT_DIFFICULTY: Difficulty = Difficulty.NORMAL

@export var name: String = ""
@export var y_limit: int = DEFAULT_Y_LIMIT
@export var mode: Mode = DEFAULT_MODE
@export var is_hidden: bool = false
@export var description: String = ""
@export var scene: PackedScene = PackedScene.new()
@export var difficulty: Difficulty = DEFAULT_DIFFICULTY

static func mode_to_str(mode_: Mode) -> String:
	match mode_:
		Mode.RACE:
			return "ui.level.mode.race"
		Mode.BATTLE:
			return "ui.level.mode.battle"
	return "ui.unknown"

static func difficulty_to_str(diffuculty: Difficulty) -> String:
	match diffuculty:
		Difficulty.BEGINER_FRIENDLY:
			return "ui.level.difficulty.beginer_friendly"
		Difficulty.EASY:
			return "ui.level.difficulty.easy"
		Difficulty.NORMAL:
			return "ui.level.difficulty.normal"
		Difficulty.HARD:
			return "ui.level.difficulty.hard"
		Difficulty.EXTREME:
			return "ui.level.difficulty.extreme"
	return "ui.unknown"
