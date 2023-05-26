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
	HARDCORE,
	EXTREME
}

@export var scene: PackedScene = PackedScene.new()
@export var name: String = ""
@export var description: String = ""
@export var mode: Mode = Mode.RACE
@export var difficulty: Difficulty = Difficulty.NORMAL
@export var is_hidden: bool = false
