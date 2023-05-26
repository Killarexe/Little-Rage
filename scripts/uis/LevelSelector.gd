extends Control

@onready var level_list: ItemList = $CanvasLayer/LevelList
@onready var play_button: Button = $CanvasLayer/PlayButton

var level_index: int = -1

func _ready():
	play_button.disabled = true
	for level in LevelManager.levels:
		level_list.add_item(level.name)

func _on_level_list_item_selected(index):
	play_button.disabled = false
	level_index = index
	var level: Level = LevelManager.levels[index]
	

func _on_play_button_pressed():
	print(LevelManager.levels[level_index].scene.instantiate().mode)
	get_tree().change_scene_to_packed(LevelManager.levels[level_index].scene)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/uis/MainMenu.tscn")
