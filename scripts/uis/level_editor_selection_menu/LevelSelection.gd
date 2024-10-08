extends Control

@onready var level_list: LevelList = $LevelList
@onready var difficulty_color: ColorRect = $DifficultyColor
@onready var difficulty_label: Label = $DifficultyColor/Label
@onready var level_description: RichTextLabel = $DescriptionColor/LevelDescription

@onready var level_map: LevelPlayer = $"../../DefaultLevel"
@onready var level_create_import_menu: LevelCreateImportMenu = $"../LevelCreateImportMenu"
@onready var edit_button: Button = $EditButton
@onready var delete_button: Button = $DeleteButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var selected_level: String = ""

func _ready() -> void:
	animation_player.play("entry")
	difficulty_label.text = TranslationServer.translate("label.none")
	edit_button.disabled = true
	delete_button.disabled = true

func _on_level_list_on_level_selected(level: Level) -> void:
	edit_button.disabled = false
	delete_button.disabled = false
	difficulty_color.color = Level.difficulty_to_color(level.difficulty)
	difficulty_label.text = Level.difficulty_to_str(level.difficulty)
	level_description.text = level.description
	selected_level = level.id
	level_map.queue_free()
	var new_level_map = level.scene.instantiate()
	new_level_map.mode = LevelPlayer.Mode.EDIT
	get_parent().get_parent().add_child.call_deferred(new_level_map)
	level_map = new_level_map

func _on_edit_button_pressed() -> void:
	LevelManager.current_level = selected_level
	animation_player.play_backwards("entry")
	await animation_player.animation_finished
	SceneManager.change_scene("res://scenes/uis/LevelEditor.tscn")

func _on_back_button_pressed() -> void:
	animation_player.play_backwards("entry")
	await animation_player.animation_finished
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")

func _on_delete_button_pressed() -> void:
	if LevelManager.delete_level(selected_level):
		level_list.load_level_list()

func _on_create_import_level_button_pressed() -> void:
	level_create_import_menu.animation_player.play("entry")
