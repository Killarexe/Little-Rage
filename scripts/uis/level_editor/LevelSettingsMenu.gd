extends DisableEditingCursor
class_name LevelSettingsMenu

signal on_settings_changed

@onready var level_name_edit: LineEdit = $VBoxContainer/LevelName
@onready var level_description_edit: TextEdit = $VBoxContainer/LevelDescription
@onready var level_diffculty_select: OptionButton = $VBoxContainer/LevelDifficulty
@onready var level_y_limit: SpinBox = $VBoxContainer/YLimit

var y_limit: int = Level.DEFAULT_Y_LIMIT
var level_name: String = Level.DEFAULT_NAME
var description: String = Level.DEFAULT_DESCRIPTION
var difficulty: Level.Difficulty = Level.DEFAULT_DIFFICULTY

func _ready():
	level_diffculty_select.add_item("level.difficulty.beginer_friendly")
	level_diffculty_select.add_item("level.difficulty.easy")
	level_diffculty_select.add_item("level.difficulty.normal")
	level_diffculty_select.add_item("level.difficulty.hard")
	level_diffculty_select.add_item("level.difficulty.extreme")
	level_diffculty_select.select(2)
	level_y_limit.value = y_limit
	level_name_edit.text = level_name
	level_description_edit.text = description
	visible = false

func set_settings(level: Level):
	level_name = level.name
	y_limit = level.y_limit
	difficulty = level.difficulty
	description = level.description
	level_name_edit.text = level_name
	level_description_edit.text = description
	level_diffculty_select.selected = int(difficulty)
	level_y_limit.set_value_no_signal(level.y_limit)

func _on_settings_button_pressed():
	visible = true

func _on_level_description_text_changed():
	description = level_description_edit.text
	on_settings_changed.emit()

func _on_level_name_text_changed(new_text):
	level_name = new_text
	on_settings_changed.emit()

func _on_level_difficulty_item_selected(index: int):
	match index:
		0:
			difficulty = Level.Difficulty.BEGINER_FRIENDLY
		1:
			difficulty = Level.Difficulty.EASY
		2:
			difficulty = Level.Difficulty.NORMAL
		3:
			difficulty = Level.Difficulty.HARD
		4:
			difficulty = Level.Difficulty.EXTREME
	on_settings_changed.emit()

func _on_slider_value_changed(value: int):
	y_limit = value
	on_settings_changed.emit()

func _on_back_button_pressed():
	visible = false
