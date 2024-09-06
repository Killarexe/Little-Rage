extends Control
class_name LevelEditor

@onready var camera: Camera2D = $Camera2D
@onready var tiles: TilesList = $CanvasLayer/Tiles
@onready var level_map: LevelPlayer = $DefaultLevel
@onready var level_settings: LevelSettingsMenu = $CanvasLayer/LevelSettingsMenu
@onready var save_confirmation_dialog: ConfirmationDialog = $CanvasLayer/SaveConfirmationDialog

var level_id: String = ""
var atlas: CompressedTexture2D = load("res://assets/textures/tilesets/tileset.png")
var tile_set: TileSet = load("res://assets/Tileset.tres")
var is_panning: bool = false
var can_place: bool = false                                                                                  
var not_saved: bool = false
var selected_tile: int = -1

func _ready():
	MusicManager.play_music("level_editor")
	can_place = Game.is_mobile
	Input.use_accumulated_input = false
	tiles.create_list(atlas);
	
	var level: Level = LevelManager.get_current_level()
	level_settings.set_settings(level)
	level_map.queue_free()
	var new_level_map: LevelPlayer = level.scene.instantiate()
	new_level_map.mode = LevelPlayer.Mode.EDIT
	add_child(new_level_map)
	level_map = new_level_map
	level_id = level.id
	LevelManager.current_level = ""
	not_saved = false

func _process(_delta: float):
	if !Game.is_mobile:
		if Input.is_action_just_pressed("pause"):
			selected_tile = -1
	queue_redraw()

func checked_if_not_saved() -> StringName:
	if not_saved:
		save_confirmation_dialog.popup_centered()
		return await save_confirmation_dialog.custom_action
	return ""

func is_editing() -> bool:
	return level_map.mode == LevelPlayer.Mode.EDIT

func _draw():
	if can_place && selected_tile >= 0 && !Game.is_mobile:
		var tile_pos: Vector2 = floor(camera.get_global_mouse_position() / 16)
		var offset: Vector2i = tiles.get_selected_tile_id(selected_tile)
		draw_texture_rect_region(atlas, Rect2(tile_pos * 16, Vector2(16, 16)), Rect2(16 * offset.x, 16 * offset.y, 16, 16), Color(1.0, 1.0, 1.0, 0.5))
	if is_editing():
		draw_texture(PlayerSkinManager.get_current_skin_texture(), Vector2(-8, -8))
		draw_texture(PlayerHatManager.get_current_hat_texture(), Vector2(-8, -24))
		

func _on_tiles_item_selected(index: int):
	selected_tile = index

func _on_tiles_empty_clicked(_at_position, _mouse_button_index):
	selected_tile = -1

func on_mouse_entered():
	if !Game.is_mobile:
		can_place = false

func on_mouse_exited():
	if !Game.is_mobile:
		can_place = true

func _on_play_button_pressed():
	if is_editing():
		camera.enabled = false
		level_map.set_mode(LevelPlayer.Mode.PLAY)
		Game.can_pause = false
	else:
		switch_edit_mode()

func switch_edit_mode():
	camera.enabled = true
	level_map.set_mode(LevelPlayer.Mode.EDIT)
	Game.can_pause = true

func _on_save_button_pressed():
	var level: Level = LevelManager.get_level(level_id)
	var packed_scene: PackedScene = PackedScene.new()
	var level_name: String = level_settings.level_name
	camera.enabled = true
	Game.can_pause = true
	level_map.set_mode(LevelPlayer.Mode.EDIT)
	level_map.mode = LevelPlayer.Mode.PLAY
	
	packed_scene.pack(level_map)
	level.name = level_name
	level.is_hidden = false
	level.scene = packed_scene
	level.y_limit = level_settings.y_limit
	level.level_theme = Level.LevelTheme.PLAINS
	level.difficulty = level_settings.difficulty
	level.description = level_settings.description
	ResourceSaver.save(level, LevelManager.EXTERNAL_LEVELS_DIR + "/" + level.id + ".tres")
	
	level_map.mode = LevelPlayer.Mode.EDIT
	
	PopUpFrame.pop(TranslationServer.translate("message.editor.saved") % level.id, load("res://assets/textures/ui/icons/save.png"))

func _on_quit_button_pressed():
	Input.use_accumulated_input = true
	var res: String = await checked_if_not_saved()
	if res == "cancel" || res.is_empty():
		SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")
	else:
		_on_save_button_pressed()
		SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")

func _on_level_settings_menu_on_settings_changed():
	not_saved = true

func _on_camera_2d_on_clicked(clicked_position: Vector2, placeing: bool):
	if selected_tile < 0 || level_settings.visible:
		can_place = false
	
	if can_place:
		var tile_pos: Vector2i = floor(clicked_position / 16)
		if placeing:
			tiles.editor_tiles[selected_tile].on_place(level_map, tile_pos)
			not_saved = true
		else:
			level_map.remove_tile_and_update(tile_pos)
			not_saved = true

func _on_back_to_center_button_pressed():
	camera.offset = Vector2(0, 0)
