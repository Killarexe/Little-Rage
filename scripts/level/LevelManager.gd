extends Node

const LEVEL_DIR_PATH: String = "res://data/levels"
const EXTERNAL_LEVELS_DIR: String = "user://levels"

var levels: Array[Level] = []
var current_level: String = ""
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
