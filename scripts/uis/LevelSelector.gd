extends Control

@onready var level_list: ItemList = $CanvasLayer/LevelList

@onready var play_button: Button = $CanvasLayer/PlayButton
@onready var edit_level_button: Button = $CanvasLayer/EditButton
@onready var level_create_button: Button = $CanvasLayer/CreateButton

@onready var level_difficulty: Label = $CanvasLayer/VBoxContainer/LevelDifficulty
@onready var level_description_label: Label = $CanvasLayer/VBoxContainer/LevelDescription
@onready var level_best_time_label: Label = $CanvasLayer/VBoxContainer/LevelBestTime

@onready var level_desciprtion: RichTextLabel = $CanvasLayer/VBoxContainer/LevelDescription/ColorRect/RichTextLabel
@onready var level_settings_menu: LevelSettingsMenu = $CanvasLayer/LevelSettingsMenu

var level_index: int = -1
var levels: Array[int] = []

func _ready():
	MusicManager.play_music("level_selection")
	get_tree().paused = false
	play_button.disabled = true
	var index: int = 0
	for level in LevelManager.levels:
		if !level.is_hidden:
			level_list.add_item(level.name)
			levels.append(index)
		index += 1
	level_list.select(0)
	_on_level_list_item_selected(0)

func _on_level_list_item_selected(index):
	play_button.disabled = false
	level_index = levels[index]
	var level: Level = LevelManager.levels[level_index]
	var is_default_level: bool = LevelManager.is_default_level(level.id)
	edit_level_button.disabled = is_default_level
	if is_default_level:
		level_desciprtion.text = TranslationServer.translate(level.description)
	else:
		level_desciprtion.text = level.description
	level_description_label.text =  TranslationServer.translate("level.description") + ": "
	level_difficulty.text = TranslationServer.translate("level.difficulty") + ":\n    " + TranslationServer.translate(Level.difficulty_to_str(level.difficulty)) + "\n"
	level_best_time_label.text = TranslationServer.translate("level.best_time") + ": " + LevelManager.get_level_best_time_as_str(level.id)

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
		level_create_button.text = TranslationServer.translate("button.create_level")
		level_settings_menu.visible = false
	else:
		level_create_button.text = TranslationServer.translate("button.back")
		level_settings_menu.visible = true

func go_to_editor():
	LevelManager.current_level = LevelManager.levels[level_index].id
	SceneManager.change_scene("res://scenes/uis/LevelEditor.tscn")

func _on_edit_button_pressed():
	if Global.is_mobile:
		ExperiementalFrame.pop(go_to_editor, func():pass)
	else:
		go_to_editor()

func create_level():
	var level: Level = Level.new()
	var packed_scene: PackedScene = load("res://scenes/instances/level/DefaultLevel.tscn")
	var level_name: String = level_settings_menu.level_name
	if level_name == "DoYeah":
		for hat in PlayerHatManager.hats:
			PlayerHatManager.unlock_hat(hat.id)
		for skin in PlayerSkinManager.skins:
			PlayerSkinManager.unlock_skin(skin.id)
	level.name = level_name
	level.is_hidden = false
	level.scene = packed_scene
	level.mode = Level.Mode.RACE
	level.y_limit = level_settings_menu.y_limit
	level.level_theme = Level.LevelTheme.PLAINS
	level.difficulty = level_settings_menu.difficulty
	level.description = level_settings_menu.description
	level.id = level_name.to_lower().replace(" ", "_")
	ResourceSaver.save(level, LevelManager.EXTERNAL_LEVELS_DIR + "/" + level.id + ".tres")
	LevelManager.load_levels()
	LevelManager.current_level = level.id
	SceneManager.change_scene("res://scenes/uis/LevelEditor.tscn")

func _on_create_level_button_pressed():
	if Global.is_mobile:
		ExperiementalFrame.pop(create_level, func():pass)
	else:
		create_level()
