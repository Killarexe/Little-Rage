extends Control
class_name LevelCreateImportMenu

@onready var level_creation_menu: LevelSettingsMenu = $LevelCreation
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var file_dialog: FileDialog = $FileDialog

func _ready() -> void:
	file_dialog.root_subfolder = OS.get_user_data_dir()
	position.x = -1280

func _on_create_button_pressed() -> void:
	level_creation_menu.visible = true
	animation_player.play("entry_second")

func _on_import_button_pressed() -> void:
	file_dialog.popup_centered()
	animation_player.play("entry_third")

#Maybe this needs some optimisation...
func _on_file_dialog_file_selected(path: String) -> void:
	file_dialog.visible = true
	animation_player.play_backwards("entry_third")
	await animation_player.animation_finished
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var file_error: Error = FileAccess.get_open_error()
	var error_icon: Texture2D = load("res://assets/textures/ui/icons/quit.png")
	var ok_icon: Texture2D = load("res://assets/textures/ui/icons/ok.png")
	if file_error != OK:
		PopUpFrame.pop(TranslationServer.translate("popup.failed_load_level.read_file") % file_error, error_icon)
		return
	
	#To doge hacks and false files...
	var file_contents: String = file.get_as_text()
	if file_contents.is_empty() || file_contents.contains("GDScript") || !file_contents.begins_with("[gd_resource type=\"Resource\" script_class=\"Level\""):
		PopUpFrame.pop_translated("popup.failed_load_level.invalid_file", error_icon)
		return
	
	var dir_array: PackedStringArray = path.split("/")
	var file_name: String = dir_array[dir_array.size() - 1]
	var level_id: String = file_name.replace(".tres", "")
	if level_id.is_empty():
		PopUpFrame.pop_translated("popup.failed_load_level.invaild_id")
		return
	if LevelManager.get_level(level_id) != null:
		PopUpFrame.pop(TranslationServer.translate("popup.failed_load_level.sheared_id") % level_id, error_icon)
		return
	
	var new_file: FileAccess = FileAccess.open(LevelManager.EXTERNAL_LEVELS_DIR + "/" + file_name, FileAccess.WRITE_READ)
	var new_file_error: Error = FileAccess.get_open_error()
	if new_file_error:
		PopUpFrame.pop(TranslationServer.translate("popup.failed_load_level.copy_file") % new_file_error, error_icon)
		return
	
	new_file.store_string(file_contents)
	LevelManager.load_levels()
	PopUpFrame.pop(TranslationServer.translate("popup.load_level_success") % level_id, ok_icon)

func _on_create_level_button_pressed() -> void:
	var level: Level = Level.new()
	var level_id: String = level_creation_menu.level_name.to_lower().replace(" ", "_")
	level.name = level_creation_menu.level_name
	level.description = level_creation_menu.description
	level.y_limit = level_creation_menu.y_limit
	level.difficulty = level_creation_menu.difficulty
	level.scene = load("res://scenes/bundles/DefaultLevel.tscn")
	ResourceSaver.save(level, LevelManager.EXTERNAL_LEVELS_DIR + "/" + level_id + ".tres")
	AchievementManager.unlock_achievement("making_my_own")
	LevelManager.load_levels()
	LevelManager.current_level = level_id
	SceneManager.change_scene("res://scenes/uis/LevelEditor.tscn")

func _on_back_button_pressed() -> void:
	animation_player.play_backwards("entry")

func _on_file_dialog_canceled() -> void:
	animation_player.play_backwards("entry_third")
