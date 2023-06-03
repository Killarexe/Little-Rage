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

static func mode_to_str(mode: Mode) -> String:
	match mode:
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

@export var scene: PackedScene = PackedScene.new()
@export var name: String = ""
@export var description: String = ""
@export var mode: Mode = Mode.RACE
@export var difficulty: Difficulty = Difficulty.NORMAL
@export var is_hidden: bool = false
