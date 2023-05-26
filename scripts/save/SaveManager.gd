class_name SaveManager

const SAVE_FILE: String = "user://save.json"
const DEFAULT_SAVE: Dictionary = {
	"unlocked_hats": [],
	"unlocked_skins": ["default"],
	"unhidden_hats": [],
	"unhidden_skins": [],
	"coins": 0
}

func save():
	pass

func create_save():
	var save_file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	save_file.store_string(JSON.stringify(DEFAULT_SAVE))
	save_file.close()

func load_save():
	if !FileAccess.file_exists(SAVE_FILE):
		create_save()
	var save_file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.READ)
	var data: Dictionary = JSON.parse_string(save_file.get_as_text())
	if data:
		Global.coins = data["coins"]
