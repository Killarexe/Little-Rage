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

static func mode_to_str(level_mode: Mode) -> String:
	match level_mode:
		Mode.RACE:
			return "level.mode.race"
		Mode.BATTLE:
			return "level.mode.battle"
	return "unknown"

static func difficulty_to_str(level_diffuculty: Difficulty) -> String:
	match level_diffuculty:
		Difficulty.BEGINER_FRIENDLY:
			return "label.level.difficulty.beginer_friendly"
		Difficulty.EASY:
			return "label.level.difficulty.easy"
		Difficulty.NORMAL:
			return "label.level.difficulty.normal"
		Difficulty.HARD:
			return "label.level.difficulty.hard"
		Difficulty.EXTREME:
			return "label.level.difficulty.extreme"
	return "label.unknown"

static func difficulty_to_color(level_diffuculty: Level.Difficulty) -> Color:
	match level_diffuculty:
		Level.Difficulty.BEGINER_FRIENDLY:
			return Color.LIME_GREEN
		Level.Difficulty.EASY:
			return Color.SEA_GREEN
		Level.Difficulty.NORMAL:
			return Color.GREEN_YELLOW
		Level.Difficulty.HARD:
			return Color.ORANGE_RED
		Level.Difficulty.EXTREME:
			return Color.RED
	return Color.SEA_GREEN
