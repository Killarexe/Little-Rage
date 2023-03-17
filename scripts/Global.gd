extends Node

const ON_TILE: Vector2i = Vector2i(0, 5)
const OFF_TILE: Vector2i = Vector2i(0, 6)
const RED_FULL_TILE: Vector2i = Vector2i(1, 5)
const RED_EMPTY_TILE: Vector2i = Vector2i(1, 6)
const BLUE_FULL_TILE: Vector2i = Vector2i(1, 7)
const BLUE_EMPTY_TILE: Vector2i = Vector2i(1, 8)
const CHECKPOINT_ON_TILE: Vector2i = Vector2i(2, 3)
const CHECKPOINT_OFF_TILE: Vector2i = Vector2i(4, 3)

var coins: int = 0
var currentLevel: int
var ableToPause: bool = true
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

func instanceNodeAtPos(node: Object, parent: Object, pos: Vector2) -> Object:
	var nodeInstance = instanceNode(node, parent)
	nodeInstance.global_position = pos
	return nodeInstance

func instanceNode(node: Object, parent: Object) -> Object:
	var nodeInstance = node.instantiate()
	parent.add_child(nodeInstance)
	return nodeInstance 

func saveGame():
	var saveFile: FileAccess = FileAccess.open(saveFilePath, FileAccess.WRITE)
	var data ={
		"coins": coins,
		"hats": HatManager.HATS,
		"current_skin": SkinManager.current_skin,
		"music_volume": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")),
		"sfxs_volume": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFXS")),
		"skins": SkinManager.SKINS,
		"levels": LevelManager.LEVELS
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
	SkinManager.current_skin = get_save_data(data, "current_skin", 0)
	HatManager.HATS = get_save_data(data, "hats", HatManager.HATS)
	SkinManager.SKINS = get_save_data(data, "skins", SkinManager.SKINS)
	LevelManager.LEVELS = get_save_data(data, "levels", LevelManager.LEVELS)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		get_save_data(data, "music_volume", 0)
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFXS"),
		get_save_data(data, "sfxs_volume", 0)
	)
	saveFile.close()
	if OS.is_debug_build() && SkinManager.current_skin == 0:
		SkinManager.current_skin = 7

func resetGame():
	var saveFile: FileAccess = FileAccess.open(saveFilePath, FileAccess.WRITE)
	var data ={
		"coins": 0,
		"current_skin": 0,
		"hats": HatManager.HATS_DEFAULT,
		"skins": SkinManager.SKINS_DEFAULT,
		"levels": LevelManager.LEVELS_DEFAULT,
		"music_volume": 0,
		"sfxs_volume": 0
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

