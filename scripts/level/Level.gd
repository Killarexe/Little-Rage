extends ResourceElement
class_name Level

enum LevelTheme {
	PLAINS,
	CAVES,
	VOLCANO,
	MOUNTAINS
}

const LEVEL_THEME_STRS: PackedStringArray = [
	"plains",
	"caves",
	"volcano",
	"mountains"
] 

enum Difficulty {
	BEGINER_FRIENDLY,
	EASY,
	NORMAL,
	HARD,
	EXTREME
}

const DIFFICULTY_STRS: PackedStringArray = [
	"label.level.difficulty.beginer_friendly",
	"label.level.difficulty.easy",
	"label.level.difficulty.normal",
	"label.level.difficulty.hard",
	"label.level.difficulty.extreme"
]

const DIFFICULTY_COLORS: Array[Color] = [
	Color.LIME_GREEN,
	Color.SEA_GREEN,
	Color.GREEN_YELLOW,
	Color.ORANGE_RED,
	Color.RED
]

const DEFAULT_NAME: String = "MyLevel"
const DEFAULT_Y_LIMIT: int = 512
const DEFAULT_DESCRIPTION: String = "Hello, world!"
const DEFAULT_DIFFICULTY: Difficulty = Difficulty.NORMAL

@export var name: String = ""
@export var is_hidden: bool = false
@export_multiline var description: String = ""
@export_range(128, 1024) var y_limit: int = DEFAULT_Y_LIMIT
@export var scene: PackedScene = PackedScene.new()
@export var level_theme: LevelTheme = LevelTheme.PLAINS
@export var difficulty: Difficulty = DEFAULT_DIFFICULTY

static func level_theme_to_translation_str(theme: LevelTheme) -> String:
	return "label.level.theme." + LEVEL_THEME_STRS[theme]

static func level_theme_to_str(theme: LevelTheme) -> String:
	return LEVEL_THEME_STRS[theme]

static func get_level_theme_color(theme: LevelTheme) -> Color:
	match theme:
		LevelTheme.PLAINS:
			return Color.hex(0x3CBCFCFF)
		LevelTheme.CAVES:
			return Color.hex(0x1b1c28FF)
		LevelTheme.VOLCANO:
			return Color.hex(0x1b1c28FF)
		LevelTheme.MOUNTAINS:
			Color.hex(0x80cff7FF)
	return Color.hex(0x3CBCFCFF)

static func difficulty_to_str(level_difficulty: Difficulty) -> String:
	if level_difficulty < DIFFICULTY_STRS.size():
		return DIFFICULTY_STRS[level_difficulty]
	return "label.unknown"

static func difficulty_to_color(level_difficulty: Level.Difficulty) -> Color:
	if level_difficulty < DIFFICULTY_COLORS.size():
		return DIFFICULTY_COLORS[level_difficulty]
	return Color.SEA_GREEN
