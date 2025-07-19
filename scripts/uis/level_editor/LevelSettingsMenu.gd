extends Control
class_name LevelSettingsMenu

signal on_settings_changed()

@export var level_name_edit: LineEdit
@export var level_description_edit: TextEdit
@export var level_difficulty_buttons: ButtonList
@export var level_theme_buttons: ButtonList

var y_limit: int = Level.DEFAULT_Y_LIMIT
var level_name: String = Level.DEFAULT_NAME
var description: String = Level.DEFAULT_DESCRIPTION
var difficulty: Level.Difficulty = Level.DEFAULT_DIFFICULTY
var level_theme: Level.LevelTheme = Level.LevelTheme.PLAINS

func _ready() -> void:
  #level_y_limit.value = y_limit
  level_name_edit.text = level_name
  level_description_edit.text = description
  
  level_name_edit.text_changed.connect(on_level_name_text_changed)
  level_description_edit.text_changed.connect(on_level_description_text_changed)
  level_difficulty_buttons.button_toggled.connect(on_level_difficulty_changed)
  level_theme_buttons.button_toggled.connect(on_level_theme_changed)
  
  level_difficulty_buttons.select(int(difficulty))
  level_theme_buttons.select(int(level_theme))
  
  #visible = false

func set_settings(level: Level) -> void:
  level_name = level.name
  y_limit = level.y_limit
  difficulty = level.difficulty
  description = level.description
  level_name_edit.text = level_name
  level_description_edit.text = description
  level_difficulty_buttons.select(int(difficulty))
  level_theme_buttons.select(int(level_theme))
  #level_y_limit.set_value_no_signal(level.y_limit)

func _on_settings_button_pressed() -> void:
  visible = true

func on_level_description_text_changed() -> void:
  description = level_description_edit.text
  on_settings_changed.emit()

func on_level_name_text_changed(new_text: String) -> void:
  level_name = new_text
  on_settings_changed.emit()

func on_level_difficulty_changed(index: int) -> void:
  difficulty = index
  on_settings_changed.emit()

func on_level_theme_changed(index: int) -> void:
  level_theme = index
  on_settings_changed.emit()

func _on_back_button_pressed() -> void:
  visible = false
