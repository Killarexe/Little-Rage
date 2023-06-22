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
	"discord_rpc": true,
	"lang": "en"
}

func save():
	if !FileAccess.file_exists(SAVE_FILE):
		create_save()
	var save_file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	var data: Dictionary = DEFAULT_SAVE.duplicate()
	
	data["music_volume"] = MusicManager.music_volume
	data["sound_effects_volume"] = MusicManager.sound_effect_volume
	data["lang"] = TranslationServer.get_locale()
	data["discord_rpc"] = DiscordRPCManager.enable_discord_rpc
	
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
		TranslationServer.set_locale(get_or_create_value(data, "lang"))
		MusicManager.set_music_volume(get_or_create_value(data, "music_volume"))
		MusicManager.sound_effect_volume = get_or_create_value(data, "sound_effects_volume")
		DiscordRPCManager.enable_discord_rpc = get_or_create_value(data, "discord_rpc")
