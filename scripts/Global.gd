extends Node

const ON_TILE: Vector2i = Vector2i(0, 5)
const OFF_TILE: Vector2i = Vector2i(0, 6)
const RED_FULL_TILE: Vector2i = Vector2i(1, 5)
const RED_EMPTY_TILE: Vector2i = Vector2i(1, 6)
const BLUE_FULL_TILE: Vector2i = Vector2i(1, 7)
const BLUE_EMPTY_TILE: Vector2i = Vector2i(1, 8)

var skins = {
	0:[load("res://textures/skins/player.png"), 0], 
	1:[load("res://textures/skins/playergb.png"), 20],
	2:[load("res://textures/skins/playerlava.png"), 20],
	3:[load("res://textures/skins/playernegative.png"), 20],
	4:[load("res://textures/skins/playersteve.png"), 30],
	5:[load("res://textures/skins/playerwater.png"), 10],
	6:[load("res://textures/skins/playerniark.png"), 0],
	7:[load("res://textures/skins/playerexe.png"), 0]
}

var musics = {
	0: load("res://sounds/musics/level_select.mp3"),
	1: load("res://sounds/musics/nofall.wav"),
	2: load("res://sounds/musics/level_one.mp3"),
	3: load("res://sounds/musics/shop.mp3"),
	4: load("res://sounds/musics/easter.mp3"),
}

var hats = {
	
}

var levels: Array = [
	0,
	1,
	2
]


var coins: int = 0
var currentLevel: int
var currentSkin: int = 0
var ableToPause: bool = true
var levels_timers: Array = []
var unlocked_hats: Array = [0]
var unlockedSkins: Array = [0]
var unlockedLevels: Array = [0]
var editor_playing: bool = false
var settings_clicked: int = 0

const saveFilePath = "user://player_save.save"

func _ready():
	loadGame()

func wait(sec: int, node: Node):
	var t = Timer.new()
	t.set_wait_time(sec)
	t.set_one_shot(true)
	node.add_child(t)
	t.start()
	await t.timeout
	t.queue_free()

func play_music(id: int):
	MusicPlayer.stop()
	MusicPlayer.stream = musics[id];
	MusicPlayer.play()

func instanceNodeAtPos(node: Object, parent: Object, pos: Vector2) -> Object:
	var nodeInstance = instanceNode(node, parent)
	nodeInstance.global_position = pos
	return nodeInstance

func instanceNode(node: Object, parent: Object) -> Object:
	var nodeInstance = node.instantiate()
	parent.add_child(nodeInstance)
	return nodeInstance 

func unlockNextLevel():
	var id = currentLevel + 1
	if(unlockedLevels.size() != levels.size() && !unlockedLevels.has(id)):
		unlockedLevels.append(id)
		saveGame()

func unlockSkin(skin: int):
	if(!unlockedSkins.has(skin) && skins[skin][1] <= coins):
		unlockedSkins.append(skin)
		addCoins(-Global.skins[skin][1])
	saveGame()

func unlock_hat(_hat: int):
	pass

func set_current_hat(_hat: int):
	pass

func setCurrentSkin(skin):
	if(unlockedSkins.has(skin)):
		currentSkin = skins[skin]

func saveGame():
	var saveFile: FileAccess = FileAccess.open(saveFilePath, FileAccess.WRITE)
	var data ={
		"coins": coins,
		#"hats": unlocked_hats,
		"current_skin": currentSkin,
		"music_volume": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")),
		"sfxs_volume": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFXS")),
		"skins": unlockedSkins,
		"levels": unlockedLevels
	}
	saveFile.store_string(JSON.stringify(data))
	saveFile.close()

func get_save_data(data: Dictionary, name: String, default_value):
	if(data.has(name)):
		return data[name]
	return default_value

func loadGame():
	if(!FileAccess.file_exists(saveFilePath)):
		saveGame()
		loadGame()
		return
	var saveFile: FileAccess = FileAccess.open(saveFilePath, FileAccess.READ)
	var data = JSON.parse_string(saveFile.get_as_text())
	if(data == null):
		saveGame()
		loadGame()
		return
	coins = get_save_data(data, "coins", 0)
	currentSkin = get_save_data(data, "current_skin", 0)
	unlocked_hats = get_save_data(data, "hats", [0])
	unlockedSkins =get_save_data(data, "skins", [0])
	unlockedLevels = get_save_data(data, "levels", [0])
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		get_save_data(data, "music_volume", 0)
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFXS"),
		get_save_data(data, "sfxs_volume", 0)
	)
	saveFile.close()
	if OS.is_debug_build() && Global.currentSkin == 0:
		Global.currentSkin = 7

func resetGame():
	var saveFile: FileAccess = FileAccess.open(saveFilePath, FileAccess.WRITE)
	var data ={
		"coins": 0,
		"hats": [0],
		"skins": [0],
		"levels": [0] 
	}
	saveFile.store_string(JSON.stringify(data))
	saveFile.close()
	loadGame()

func addCoins(addedCoins):
	coins += addedCoins
	saveGame()

func ablePause():
	ableToPause = true

func unablePause():
	ableToPause = false

