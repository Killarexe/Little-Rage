extends Node

const LEVEL_DIR_PATH: String = "res://data/levels"
const EXTERNAL_LEVELS_DIR: String = "user://levels"
const TILEMAP_TEXTURES_DIR: String = "res://assets/textures/tilesets/"
const TILEMAP_TEXTURES_MAP: Array = [
	["plains", "plains_old", "plains_christmas", "plains"],
	["caves", "caves", "caves", "caves"],
	["volcano", "volcano", "volcano", "volcano"],
	["mountains", "mountains", "mountains", "mountains"]
]

var levels: Array[Level] = []
var current_level: String = ""
var levels_best_times: Dictionary = {}
var default_levels: Array[String] = []

func _ready() -> void:
	load_levels()

func load_levels() -> void:
	levels.clear()
	var resources: Array[ResourceElement] = DataLoader.new().load_data_in_dir(LEVEL_DIR_PATH, "level")
	for resource in resources:
		if resource is Level:
			default_levels.append(resource.id)
			levels.append(resource)
	if !DirAccess.dir_exists_absolute(LevelManager.EXTERNAL_LEVELS_DIR):
		DirAccess.make_dir_absolute(LevelManager.EXTERNAL_LEVELS_DIR)
	var external_resources: Array[ResourceElement] = DataLoader.new().load_data_in_dir(EXTERNAL_LEVELS_DIR, "level")
	for resource in external_resources:
		if resource is Level:
			levels.append(resource) 

func get_level_best_time_as_str(level_id: String) -> String:
	var best_time: Array = get_level_best_time(level_id)
	if best_time == [0, 0, 0]:
		return TranslationServer.translate("label.none")
	return str(int(best_time[0])).pad_zeros(2) + ":" + str(int(best_time[1])).pad_zeros(2) + ":" + str(int(best_time[2])).pad_zeros(2)

func get_level_best_time(level_id: String) -> Array:
	return levels_best_times.get(level_id, [0, 0, 0])

func time_to_int(time: Array) -> int:
	return int(str(time[0]).pad_zeros(2) + str(time[1]).pad_zeros(2) + str(time[2]).pad_zeros(2))

func is_best_time(current_time: Array[int]) -> bool:
	var best_time: Array = get_level_best_time(current_level)
	if best_time == [0, 0, 0]:
		return true
	if time_to_int(best_time) > time_to_int(current_time):
		AchievementManager.unlock_achievement("new_record")
		return true
	return false

func set_level_best_time(time: Array[int]) -> void:
	levels_best_times[current_level] = time
	SaveManager.save()

func is_default_level(level_id: String) -> bool:
	return default_levels.has(level_id)

func get_current_level() -> Level:
	return get_level(current_level)

func get_level(level_id: String) -> Level:
	for level in levels:
		if level.id == level_id:
			return level
	return null

func load_level(level_id: String) -> void:
	var level: Level = get_level(level_id)
	get_tree().change_scene_to_packed(level.scene)

func get_tilemap_texture() -> Texture2D:
	var level: Level = get_current_level()
	var theme: Level.LevelTheme = Level.LevelTheme.PLAINS
	if level != null:
		theme = level.level_theme
	var file_name: String = "plains"
	if theme < TILEMAP_TEXTURES_MAP.size():
		file_name = TILEMAP_TEXTURES_MAP[theme][Game.current_event]
	var file_path: String = TILEMAP_TEXTURES_DIR + file_name + ".png"
	if FileAccess.file_exists(file_path):
		return load(file_path) as CompressedTexture2D
	return load(TILEMAP_TEXTURES_DIR + "plains.png") as CompressedTexture2D

func delete_level(level_id: String) -> bool:
	print_rich("[b]Try Deleting '%s/%s.tres'[/b]" % [EXTERNAL_LEVELS_DIR, level_id])
	var level_dir: DirAccess = DirAccess.open(EXTERNAL_LEVELS_DIR)
	var error: Error = level_dir.remove(level_id + ".tres")
	if error == OK:
		load_levels()
		print_rich("[color=lightgree][i]\"%s\" succesfully deleted![/i][/color]" % level_id)
		PopUpFrame.pop_translated("popup.delete_level.success", load("res://assets/textures/ui/icons/ok.png"))
		return true
	print_rich("[color=red][b]Failed to delete \"%s\":\n\t" + str(error))
	PopUpFrame.pop(TranslationServer.translate("popup.delete_level.failed" % level_dir), load("res://assets/textures/ui/icons/quit.png"))
	return false
