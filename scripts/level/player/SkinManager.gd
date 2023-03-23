extends Node

const SKINS: Array = [
	["res://textures/skins/player.png", 0], 
	["res://textures/skins/playergb.png", 20],
	["res://textures/skins/playerlava.png", 20],
	["res://textures/skins/playernegative.png", 20],
	["res://textures/skins/playersteve.png", 30],
	["res://textures/skins/playerwater.png", 10],
	["res://textures/skins/playerrgb.png", 0],
	["res://textures/skins/playerniark.png", 0],
	["res://textures/skins/playerexe.png", 0]
]

const SKINS_DEFAULT: Array = [
	[true, true],
	[false, true],
	[false, true],
	[false, true],
	[false, true],
	[false, true],
	[false, false],
	[false, false],
	[false, false]
]

var SKINS_SAVE: Array = SKINS_DEFAULT

var current_skin: int = 0

func merge_save_default():
	SKINS_SAVE.resize(SKINS_DEFAULT.size())
	for i in range(0, SKINS_DEFAULT.size()):
		if SKINS_SAVE[i].size() == SKINS_DEFAULT[i].size():
			break;
		SKINS_SAVE[i].resize(SKINS_DEFAULT[i].size())
		if SKINS_SAVE[i] == null:
			SKINS_SAVE[i] = SKINS_DEFAULT[i]
		for j in range(0, SKINS_DEFAULT[i].size()):
			if SKINS_SAVE[i][j] == null:
				SKINS_SAVE[i][j] = SKINS_DEFAULT[i][j]

func get_skin_texture(id: int) -> Resource:
	return load(get_skin_property(id, 0))

func get_skin_property(id: int, properity: int) -> Variant:
	return SKINS[id][properity]

func get_save_skin_property(id: int, properity: int) -> Variant:
	return SKINS_SAVE[id][properity]

func get_current_skin_texture() -> Resource:
	return load(get_skin_property(current_skin, 0))

func is_hidden(id: int):
	return !get_save_skin_property(id, 1) && !OS.is_debug_build()

func get_skin_cost(id: int):
	return get_skin_property(id, 1)

func is_skin_unlocked(id: int):
	return get_save_skin_property(id, 0)

func unhide_skin(id: int):
	SKINS_SAVE[id][1] = true
	Global.saveGame()

func unlock_skin(id: int):
	if Global.coins >= get_skin_cost(id):
		Global.coins -= get_skin_cost(id)
		SKINS_SAVE[id][0] = true
	Global.saveGame()

func equip_skin(id: int):
	if is_skin_unlocked(id):
		current_skin = id
	Global.saveGame()
