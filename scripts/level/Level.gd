extends ResourceElement
class_name Level

enum Mode{
	RACE,	#Classic singleplayer
	BATTLE	#Classic multiplayer
}

enum LevelTheme{
	PLAINS,
	CAVES,
	HEAVEN,
	VOLCANO,
	DESERT,
	ICE_DESERT
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
@export var is_hidden: bool = false
@export_multiline var description: String = ""
@export var mode: Mode = DEFAULT_MODE
@export_range(256, 1024) var y_limit: int = DEFAULT_Y_LIMIT
@export var scene: PackedScene = PackedScene.new()
@export var level_theme: LevelTheme = LevelTheme.PLAINS
@export var difficulty: Difficulty = DEFAULT_DIFFICULTY

static func mode_to_str(mode: Mode) -> String:
	match mode:
		Mode.RACE:
			return "level.mode.race"
		Mode.BATTLE:
			return "level.mode.battle"
	return "unknown"

static func difficulty_to_str(diffuculty: Difficulty) -> String:
	match diffuculty:
		Difficulty.BEGINER_FRIENDLY:
			return "level.difficulty.beginer_friendly"
		Difficulty.EASY:
			return "level.difficulty.easy"
		Difficulty.NORMAL:
			return "level.difficulty.normal"
		Difficulty.HARD:
			return "level.difficulty.hard"
		Difficulty.EXTREME:
			return "level.difficulty.extreme"
	return "unknown"
