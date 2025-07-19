extends Node
class_name LevelEditor

@export var level_map: LevelPlayer
@export var level_editor_camera: LevelEditorCamera
@export var level_gui: LevelEditorGUI
@export var level_settings: LevelSettingsMenu
@export var brush: BrushComponent
@export var tiles_button: TilesButton
@export var player_sprite: PlayerSkinSprite

func _ready() -> void:
  if !level_settings.is_node_ready():
    await level_settings.ready
  level_settings.on_settings_changed.connect(on_settings_changed)
  Game.can_pause = false
  MusicManager.play_music("level_editor") #TODO: Depends on the level theme

func on_settings_changed() -> void:
  level_map.set_level_theme(level_settings.level_theme)
  level_gui.tiles_list.create_list(level_map.ground.tile_set.get_source(1).texture)
  tiles_button.update_tiles_button_texture(brush.selected_tile)

func save_level() -> void:
  var level: Level = Level.new()
  var level_scene: PackedScene = PackedScene.new()
  var level_name: String = level_settings.level_name
  var level_id: String = level_settings.level_name.replace(" ", "_").to_lower()
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
  if LevelManager.get_level(level_id) == null:
    LevelManager.load_levels()
  PopUpFrame.pop(TranslationServer.translate("message.editor.saved") % level.id, load("res://assets/textures/ui/icons/save.png"))

func on_play_button_pressed() -> void:
  var is_playing: bool = level_map.mode == LevelPlayer.Mode.PLAY
  level_gui.visible = is_playing
  level_gui.camera.enabled = is_playing
  level_gui.grid.visible = is_playing
  player_sprite.visible = is_playing
  level_editor_camera.can_move = is_playing
  if is_playing:
    level_map.set_mode(LevelPlayer.Mode.EDIT)
  else:
    level_map.set_mode(LevelPlayer.Mode.PLAY)

func load_level(path: String) -> void:
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
  if LevelManager.get_level(level_id) == null:
    var new_file: FileAccess = FileAccess.open(LevelManager.EXTERNAL_LEVELS_DIR + "/" + file_name, FileAccess.WRITE_READ)
    var new_file_error: Error = FileAccess.get_open_error()
    if new_file_error:
      PopUpFrame.pop(TranslationServer.translate("popup.failed_load_level.copy_file") % new_file_error, error_icon)
      return
    new_file.store_string(file_contents)
    LevelManager.load_levels()
  
  var level_resource: Resource = load(path)
  if level_resource is Level:
    level_settings.set_settings(level_resource)
    var new_level_map = level_resource.scene.instantiate()
    new_level_map.mode = LevelPlayer.Mode.EDIT
    level_map.queue_free()
    add_child(new_level_map)
    level_map = new_level_map
    level_gui.level = level_map
    brush.level = level_map
    tiles_button.level = level_map
  PopUpFrame.pop(TranslationServer.translate("popup.load_level_success") % level_id, ok_icon)
