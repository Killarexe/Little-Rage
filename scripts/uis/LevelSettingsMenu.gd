extends DisableEditingCursor
class_name LevelSettingsMenu

@onready var level_name_edit: LineEdit = $VBoxContainer/LevelName
@onready var level_description_edit: TextEdit = $VBoxContainer/LevelDescription
@onready var level_diffculty_select: OptionButton = $VBoxContainer/LevelDifficulty

var level_name: String = "MyLevel"
var description: String = "Hello, world!"
var difficulty: Level.Difficulty = Level.Difficulty.NORMAL

func setup():
	visible = !visible
	if visible:
		emit_signal("mouse_entered")
	else:
		emit_signal("mouse_exited")

func _ready():
	level_diffculty_select.add_item("ui.level.difficulty.beginer_friendly")
	level_diffculty_select.add_item("ui.level.difficulty.easy")
	level_diffculty_select.add_item("ui.level.difficulty.normal")
	level_diffculty_select.add_item("ui.level.difficulty.hard")
	level_diffculty_select.add_item("ui.level.difficulty.extreme")
	level_diffculty_select.select(2)
	setup()

func _on_settings_button_pressed():
	setup()


func _on_level_description_text_changed():
	description = level_description_edit.text

func _on_level_name_text_changed(new_text):
	level_name = new_text

func _on_level_difficulty_item_selected(index):
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
