extends Control

@onready var level_list: ItemList = $CanvasLayer/LevelList
@onready var play_button: Button = $CanvasLayer/PlayButton

@onready var level_difficulty: Label = $CanvasLayer/VBoxContainer/LevelDifficulty
@onready var level_description_label: Label = $CanvasLayer/VBoxContainer/LevelDescription
@onready var level_desciprtion: RichTextLabel = $CanvasLayer/VBoxContainer/LevelDescription/ColorRect/RichTextLabel

var level_index: int = -1

func _ready():
	MusicManager.play_music("level_selection")
	get_tree().paused = false
	play_button.disabled = true
	for level in LevelManager.levels:
		level_list.add_item(level.name)

func _on_level_list_item_selected(index):
	play_button.disabled = false
	level_index = index
	var level: Level = LevelManager.levels[index]
	level_desciprtion.text = level.description
	level_description_label.text =  TranslationServer.translate("ui.level.description") + ": "
	level_difficulty.text = TranslationServer.translate("ui.level.difficulty") + ":\n    " + TranslationServer.translate(Level.difficulty_to_str(level.difficulty)) + "\n"

func _on_play_button_pressed():
	var level: Level = LevelManager.levels[level_index]
	LevelManager.current_level = level.id
	DiscordRPCManager.update_rpc("Playing level '" + level.name + "'", "basicicon", "Playing level '" + level.name + "'",)
	SceneManager.change_packed(level.scene)

func _on_back_button_pressed():
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")
