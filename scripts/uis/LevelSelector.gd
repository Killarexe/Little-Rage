extends Control

@onready var level_list: ItemList = $CanvasLayer/LevelList
@onready var play_button: Button = $CanvasLayer/PlayButton

@onready var level_name: Label = $CanvasLayer/VBoxContainer/LevelName
@onready var level_description: Label = $CanvasLayer/VBoxContainer/LevelDescription
@onready var level_difficulty: Label = $CanvasLayer/VBoxContainer/LevelDifficulty

var level_index: int = -1

func _ready():
	play_button.disabled = true
	for level in LevelManager.levels:
		level_list.add_item(level.name)

func _on_level_list_item_selected(index):
	play_button.disabled = false
	level_index = index
	var level: Level = LevelManager.levels[index]
	level_name.text = TranslationServer.translate("ui.level.name") +  " : " + level.name + "\n"
	level_description.text = TranslationServer.translate("ui.level.description") + " :\n" + level.description + "\n"
	level_difficulty.text = TranslationServer.translate("ui.level.difficulty") + " :\n" + TranslationServer.translate(Level.difficulty_to_str(level.difficulty)) + "\n"

func _on_play_button_pressed():
	print(LevelManager.levels[level_index].scene.instantiate().mode)
	get_tree().change_scene_to_packed(LevelManager.levels[level_index].scene)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/uis/MainMenu.tscn")
