extends Control

@onready var level_list: ItemList = $CanvasLayer/LevelList

@onready var play_button: Button = $CanvasLayer/PlayButton
@onready var edit_level_button: Button = $CanvasLayer/EditButton

@onready var level_difficulty: Label = $CanvasLayer/VBoxContainer/LevelDifficulty
@onready var level_description_label: Label = $CanvasLayer/VBoxContainer/LevelDescription
@onready var level_best_time_label: Label = $CanvasLayer/VBoxContainer/LevelBestTime

@onready var level_desciprtion: RichTextLabel = $CanvasLayer/VBoxContainer/LevelDescription/ColorRect/RichTextLabel
@onready var level_settings_menu: LevelSettingsMenu = $CanvasLayer/LevelSettingsMenu

var level_index: int = -1

func _ready():
	MusicManager.play_music("level_selection")
	get_tree().paused = false
	play_button.disabled = true
	for level in LevelManager.levels:
		level_list.add_item(level.name)
	level_list.select(0)
	_on_level_list_item_selected(0)

func _on_level_list_item_selected(index):
	play_button.disabled = false
	level_index = index
	var level: Level = LevelManager.levels[index]
	edit_level_button.disabled = LevelManager.is_default_level(level.id)
	level_desciprtion.text = level.description
	level_description_label.text =  TranslationServer.translate("ui.level.description") + ": "
	level_difficulty.text = TranslationServer.translate("ui.level.difficulty") + ":\n    " + TranslationServer.translate(Level.difficulty_to_str(level.difficulty)) + "\n"
	level_best_time_label.text = TranslationServer.translate("ui.level.best_time") + ": " + LevelManager.get_level_best_time_as_str(level.id)

func _on_play_button_pressed():
	var level: Level = LevelManager.levels[level_index]
	LevelManager.current_level = level.id
	MusicManager.play_music("level_plains")
	SceneManager.change_packed(level.scene)
	DiscordRPCManager.update_rpc("Playing level '" + level.name + "'", "basicicon", "Playing level '" + level.name + "'",)

func _on_back_button_pressed():
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")

func _on_create_button_pressed():
	if level_settings_menu.visible:
		pass
	else:
		level_settings_menu.visible = true

func _on_edit_button_pressed():
	pass
