extends Node

const SKINS_DEFAULT = {
	0:["res://textures/skins/player.png", 0, true], 
	1:["res://textures/skins/playergb.png", 20, false],
	2:["res://textures/skins/playerlava.png", 20, false],
	3:["res://textures/skins/playernegative.png", 20, false],
	4:["res://textures/skins/playersteve.png", 30, false],
	5:["res://textures/skins/playerwater.png", 10, false],
	6:["res://textures/skins/playerniark.png", 0, false],
	7:["res://textures/skins/playerexe.png", 0, false]
}

var SKINS = SKINS_DEFAULT

var current_skin: int = 0

func get_skin_texture(id: int) -> Resource:
	return load(SKINS[str(id)][0])

func get_current_skin_texture() -> Resource:
	return load(SKINS[str(current_skin)][0])

func get_skin_cost(id: int):
	return SKINS[str(id)][1]

func is_skin_unlocked(id: int):
	return SKINS[str(id)][2]

func unlock_skin(id: int):
	var skin: Array = SKINS[str(id)]
	if Global.coins >= skin[1]:
		Global.coins -= skin[1]
		skin[2] = true

func equip_skin(id: int):
	if SKINS[str(id)][2]:
		current_skin = id
