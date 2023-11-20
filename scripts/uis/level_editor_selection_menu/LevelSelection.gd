extends Control

@onready var level_list: LevelList = $LevelList
@onready var difficulty_color: ColorRect = $DifficultyColor
@onready var difficulty_label: Label = $DifficultyColor/Label
@onready var level_description: RichTextLabel = $DescriptionColor/LevelDescription

@onready var level_map: LevelPlayer = $"../../DefaultLevel"
@onready var level_create_import_menu: Control = $"../LevelCreateImportMenu"

var selected_level: String = ""

func _ready():
	#TODO: Add entry animation
	level_list._on_item_selected(level_list.current_index)

func _on_level_list_on_level_selected(level: Level):
	difficulty_color.color = Level.difficulty_to_color(level.difficulty)
	difficulty_label.text = Level.difficulty_to_str(level.difficulty)
	level_description.text = level.description
	selected_level = level.id
	level_map.queue_free()
	var new_level_map = level.scene.instantiate()
	new_level_map.mode = LevelPlayer.Mode.EDIT
	get_parent().get_parent().add_child.call_deferred(new_level_map)
	level_map = new_level_map

func _on_edit_button_pressed():
	LevelManager.current_level = selected_level
	SceneManager.change_scene("res://scenes/uis/LevelEditor.tscn")

func _on_back_button_pressed():
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")

func _on_delete_button_pressed():
	if LevelManager.delete_level(selected_level):
		level_list.load_level_list()

func _on_create_import_level_button_pressed():
	#TODO: Add entry animation
	level_create_import_menu.visible = true
