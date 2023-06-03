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
