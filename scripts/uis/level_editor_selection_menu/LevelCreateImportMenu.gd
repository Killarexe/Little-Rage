extends Control

@onready var level_creation_menu: LevelSettingsMenu = $LevelCreation
@onready var file_dialog: FileDialog = $FileDialog

func _ready():
	file_dialog.root_subfolder = OS.get_user_data_dir()

func _on_create_button_pressed():
	#TODO: Add animation
	level_creation_menu.visible = true

func _on_import_button_pressed():
	file_dialog.popup_centered()
	#TODO: Add animation

#Maybe this needs some optimisation...
func _on_file_dialog_file_selected(path: String):
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var file_error: Error = file.get_open_error()
	if file_error != OK:
		PopUpFrame.pop("Failed to read file. Code: " + str(file_error))
		return
	
	#To doge hacks and false files...
	var file_contents: String = file.get_as_text()
	if file_contents.is_empty() || file_contents.contains("GDScript") || !file_contents.begins_with("[gd_resource type=\"Resource\" script_class=\"Level\""):
		PopUpFrame.pop("Invalid level file...")
		return
	
	var level: Level = load(path)
	var dir_array: PackedStringArray = path.split("/")
	var file_name: String = dir_array[dir_array.size() - 1]
	var level_id: String = file_name.replace(".tres", "")
	if level_id.is_empty():
		PopUpFrame.pop("Failed to load level. Invalid id '%s'." % level_id)
		return
	if LevelManager.get_level(level_id) != null:
		PopUpFrame.pop("Failed to load level. It's sharing the same id '%s'." % level_id)
		return
	
	var new_file: FileAccess = FileAccess.open(LevelManager.EXTERNAL_LEVELS_DIR + "/" + file_name, FileAccess.WRITE_READ)
	var new_file_error: Error = file.get_open_error()
	if new_file_error:
		PopUpFrame.pop("Failed to copy level into 'levels' folder. Code: " + str(new_file_error))
		return
	
	new_file.store_string(file_contents)
	LevelManager.load_levels()
	PopUpFrame.pop("Succesfuly load level '%s'." % level_id)

func _on_create_level_button_pressed():
	var level: Level = Level.new()
	var level_id: String = level_creation_menu.level_name.to_lower().replace(" ", "_")
	level.name = level_creation_menu.level_name
	level.description = level_creation_menu.level_description
	level.y_limit = level_creation_menu.y_limit
	level.difficulty = level_creation_menu.difficulty
	level.scene = load("res://scenes/instances/level/DefaultLevel.tscn")
	ResourceSaver.save(level, LevelManager.EXTERNAL_LEVELS_DIR + "/" + level_id + ".tres")
	LevelManager.load_levels()
	LevelManager.current_level = level_id
	SceneManager.change_scene("res://scenes/uis/LevelEditor.tscn")

func _on_back_button_pressed():
	#TODO: Add Animation
	visible = false
