class_name SaveManager

const SAVE_FILE: String = "user://save.json"
const DEFAULT_SAVE: Dictionary = {
	"unlocked_hats": ["no_hat"],
	"unlocked_skins": ["default"],
	"unhidden_hats": [],
	"unhidden_skins": [],
	"current_skin": "default",
	"current_hat": "",
	"level_times": {},
	"music_volume": 100.0,
	"sound_effects_volume": 100.0,
	"discord_rpc": true,
	"loot_box_count": 0,
	"window_size": 5,
	"lang": "en"
}

func save():
	if !FileAccess.file_exists(SAVE_FILE):
		create_save()
	var save_file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	var data: Dictionary = DEFAULT_SAVE.duplicate()
	
	data["window_size"] = Global.window_size
	data["lang"] = TranslationServer.get_locale()
	data["music_volume"] = MusicManager.music_volume
	data["current_hat"] = PlayerHatManager.current_hat
	data["level_times"] = LevelManager.levels_best_times
	data["current_skin"] = PlayerSkinManager.current_skin
	data["unlocked_hats"] = PlayerHatManager.unlocked_hats
	data["unhidden_hats"] = PlayerHatManager.unhidden_hats
	data["unlocked_skins"] = PlayerSkinManager.unlocked_skins
	data["unhidden_skins"] = PlayerSkinManager.unhidden_skins
	data["loot_box_count"] = Global.loot_boxes.loot_box_count
	data["discord_rpc"] = DiscordRPCManager.enable_discord_rpc
	data["sound_effects_volume"] = MusicManager.sound_effect_volume
	
	save_file.store_string(JSON.stringify(data))
	save_file.close()

func create_save():
	var save_file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	save_file.store_string(JSON.stringify(DEFAULT_SAVE))
	save_file.close()

func get_or_default(data: Dictionary, index: String):
	return data.get(index, DEFAULT_SAVE[index])

func load_save():
	if !FileAccess.file_exists(SAVE_FILE):
		create_save()
	var save_file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.READ)
	var data = JSON.parse_string(save_file.get_as_text())
	if data is Dictionary:
		Global.window_size = get_or_default(data, "window_size")
		TranslationServer.set_locale(get_or_default(data, "lang"))
		PlayerHatManager.current_hat = get_or_default(data, "current_hat")
		LevelManager.levels_best_times = get_or_default(data, "level_times")
		PlayerSkinManager.current_skin = get_or_default(data, "current_skin")
		PlayerHatManager.unhidden_hats = get_or_default(data, "unhidden_hats")
		PlayerHatManager.unlocked_hats = get_or_default(data, "unlocked_hats")
		PlayerSkinManager.unlocked_skins = get_or_default(data, "unlocked_skins")
		Global.loot_boxes.loot_box_count = get_or_default(data, "loot_box_count")
		PlayerSkinManager.unhidden_skins = get_or_default(data, "unhidden_skins")
		DiscordRPCManager.enable_discord_rpc = get_or_default(data, "discord_rpc")
		MusicManager.sound_effect_volume = get_or_default(data, "sound_effects_volume")
		MusicManager.set_music_volume(get_or_default(data, "music_volume"))
	else:
		create_save()
