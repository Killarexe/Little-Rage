extends ItemList
class_name LevelList

@export var default: bool = true
@export var custom: bool = true

var levels: Array[String] = []
var current_index: int = 0

signal on_level_selected(level: Level)

func _ready():
	load_level_list()

func load_level_list():
	levels = []
	current_index = 0
	for level in LevelManager.levels:
		var is_default: bool = LevelManager.is_default_level(level.id)
		if (is_default && default) || (!is_default && custom):
			levels.append(level.id)
			add_item(level.name)
	select(current_index)
	_on_item_selected(current_index)

func _on_item_selected(index: int):
	current_index = index
	on_level_selected.emit(LevelManager.get_level(levels[index]))

func get_level_from_selection() -> Level:
	return LevelManager.get_level(levels[current_index])
