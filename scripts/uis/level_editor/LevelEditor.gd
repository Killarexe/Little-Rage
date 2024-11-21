extends Node
class_name LevelEditor

@export var level_map: LevelPlayer
@export var tiles_list: TilesList
@export var level_settings: LevelSettingsMenu

func _ready() -> void:
	if !level_settings.is_node_ready():
		await level_settings.ready
	level_settings.on_settings_changed.connect(on_settings_changed)

func on_settings_changed() -> void:
	level_map.set_level_theme(level_settings.level_theme)
	tiles_list.create_list(level_map.ground.tile_set.get_source(1).texture)

func save_level() -> void:
	var level: Level = Level.new()
	var level_scene: PackedScene = PackedScene.new()
	var level_name: String = level_settings.name
	var level_id: String = level_settings.name.replace(" ", "_").to_lower()
	if level_name.is_empty():
		print_rich("[color=red][b]Failed to save level, the level name is empty! How did you get here?![/b][/color]")
		return
	
	level_map.mode = LevelPlayer.Mode.PLAY
	level_scene.pack(level_map)
	level.name = level_name
	level.is_hidden = false
	level.scene = level_scene
	level.y_limit = level_settings.y_limit
	level.level_theme = level_settings.level_theme
	level.difficulty = level_settings.difficulty
	level.description = level_settings.description
	level.id = level_id
	
	ResourceSaver.save(level, "{0}/{1}.tres".format([LevelManager.EXTERNAL_LEVELS_DIR, level_id]))
	
	level_map.mode = LevelPlayer.Mode.PLAY
	PopUpFrame.pop(TranslationServer.translate("message.editor.saved") % level.id, load("res://assets/textures/ui/icons/save.png"))

func load_level(path: String) -> void:
	pass
