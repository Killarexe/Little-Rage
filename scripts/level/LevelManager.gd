extends Node

const LEVEL_DIR_PATH: String = "res://data/levels"
const EXTERNAL_LEVELS_DIR: String = "user://levels"

var levels: Array[Level] = []
var current_level: String = ""
var levels_best_times: Dictionary = {}
var default_levels: Array[String] = []

func _ready():
	load_levels()

func load_levels():
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
		return "None"
	return str(best_time[0]).pad_zeros(2) + ":" + str(best_time[1]).pad_zeros(2) + ":" + str(best_time[2]).pad_zeros(2)

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

func set_level_best_time(time: Array[int]):
	levels_best_times[current_level] = time
	Global.save_game()

func is_default_level(level_id: String) -> bool:
	return default_levels.has(level_id)

func get_current_level() -> Level:
	return get_level(current_level)

func get_level(level_id: String) -> Level:
	for level in levels:
		if level.id == level_id:
			return level
	return null

func load_level(level_id: String):
	var level: Level = get_level(level_id)
	get_tree().change_scene_to_packed(level.scene)

func delete_level(level_id: String) -> bool:
	print("Try Deleting '%s/%s.tres'" % [EXTERNAL_LEVELS_DIR, level_id])
	var level_dir: DirAccess = DirAccess.open(EXTERNAL_LEVELS_DIR)
	if level_dir.remove(level_id + ".tres") == OK:
		load_levels()
		PopUpFrame.pop_translated("popup.delete_level.success")
		return true
	#PopUpFrame.pop(TranslationServer.translate("popup.delete_level.failed" % level_dir))
	PopUpFrame.pop("Failed...") #DEBUG only
	return false
