extends Node

const LEVEL_DIR_PATH: String = "res://data/levels"
const EXTERNAL_LEVELS_DIR: String = "user://levels"

var current_level: String = ""
var levels: Array[Level] = []

func _ready():
	load_levels()

func load_levels():
	levels.clear()
	var resources: Array[ResourceElement] = DataLoader.new().load_data_in_dir(LEVEL_DIR_PATH, "level")
	for resource in resources:
		if resource is Level:
			levels.append(resource)
	var external_resources: Array[ResourceElement] = DataLoader.new().load_data_in_dir(EXTERNAL_LEVELS_DIR, "level")
	for resource in external_resources:
		if resource is Level:
			levels.append(resource) 

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
