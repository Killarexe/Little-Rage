class_name SaveManager

const SAVE_FILE: String = "user://save.json"
const DEFAULT_SAVE: Dictionary = {
	"unlocked_hats": [],
	"unlocked_skins": ["default"],
	"unhidden_hats": [],
	"unhidden_skins": [],
	"level_times": {},
	"music_volume": 100.0,
	"sound_effects_volume": 100.0,
	"coins": 0
}

func save():
	if !FileAccess.file_exists(SAVE_FILE):
		create_save()
	var save_file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	var data: Dictionary = DEFAULT_SAVE.duplicate()
	
	data["coins"] = Global.coins
	
	save_file.store_string(JSON.stringify(data))
	save_file.close()

func create_save():
	var save_file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	save_file.store_string(JSON.stringify(DEFAULT_SAVE))
	save_file.close()

func get_or_create_value(data: Dictionary, index: String):
	if data.has(index):
		return data[index]
	return DEFAULT_SAVE[index]

func load_save():
	if !FileAccess.file_exists(SAVE_FILE):
		create_save()
	var save_file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.READ)
	var data: Dictionary = JSON.parse_string(save_file.get_as_text())
	if data:
		Global.coins = get_or_create_value(data, "coins")
