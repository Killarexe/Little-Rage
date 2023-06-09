extends Control
class_name LevelEditor

@onready var camera: Camera2D = $Camera2D
@onready var tiles: ItemList = $CanvasLayer/Tiles
@onready var level_map: LevelPlayer = $DefaultLevel
@onready var load_dialog: FileDialog = $CanvasLayer/LoadFileDialog
@onready var save_dialog: FileDialog = $CanvasLayer/SaveFileDialog
@onready var level_settings: LevelSettingsMenu = $CanvasLayer/LevelSettingsMenu

var atlas: CompressedTexture2D = load("res://assets/textures/tileset.png")
var tile_set: TileSet = load("res://assets/Tileset.tres")
var mouse_pos: Vector2 = Vector2()
var tile_pos: Vector2 = Vector2()
var is_panning: bool = false
var can_place: bool = false
var selected_tile: int = -1

func _ready():
	DiscordRPCManager.update_rpc("In Editor", "basicicon", "In Editor")
	var tileset_source: TileSetSource = tile_set.get_source(1)
	for tile in tileset_source.get_tiles_count():
		var atlas_coord: Vector2i = tileset_source.get_tile_id(tile) * Vector2i(16, 16)
		var region: Rect2i = Rect2i(atlas_coord, Vector2i(16, 16))
		tiles.add_icon_item(ImageTexture.create_from_image(atlas.get_image().get_region(region)))

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				camera.zoom += Vector2(0.1, 0.1)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				camera.zoom -= Vector2(0.1, 0.1)
	if event is InputEventMouseMotion:
		if is_panning:
			camera.global_position -= event.relative * camera.zoom * 1

func _process(_delta):
	mouse_pos = camera.get_global_mouse_position()
	is_panning = Input.is_action_pressed("middle_click")
	if selected_tile < 0:
		can_place = false
	if can_place:
		tile_pos = floor(mouse_pos / 16)
		if Input.is_action_pressed("left_click"):
			level_map.change_tile_and_update(tile_pos, tile_set.get_source(1).get_tile_id(selected_tile))
		elif Input.is_action_pressed("right_click"):
			level_map.remove_tile_and_update(tile_pos)
	queue_redraw()

func is_editing() -> bool:
	return level_map.mode == LevelPlayer.Mode.EDIT

func _draw():
	if can_place && selected_tile < 0:
		var offset: Vector2i = tile_set.get_source(1).get_tile_id(selected_tile)
		draw_texture_rect_region(atlas, Rect2(tile_pos * 16, Vector2(16, 16)), Rect2(16 * offset.x, 16 * offset.y, 16, 16))
	#TODO: Player spawn draw

func _on_tiles_item_selected(index):
	selected_tile = index

func _on_tiles_empty_clicked(_at_position, _mouse_button_index):
	selected_tile = -1

func on_mouse_entered():
	can_place = false

func on_mouse_exited():
	can_place = true

func _on_save_file_dialog_confirmed():
	var level: Level = Level.new()
	var tmp_array: PackedStringArray = save_dialog.current_path.split("/")
	var level_name: String = level_settings.level_name
	level_map.mode = LevelPlayer.Mode.PLAY
	var packed_scene: PackedScene = PackedScene.new()
	packed_scene.pack(level_map)
	level_map.mode = LevelPlayer.Mode.EDIT
	print(level_name)
	level.id = level_name.to_lower().replace(" ", "_")
	level.name = level_name
	level.mode = Level.Mode.RACE
	level.is_hidden = false
	level.description = level_settings.description
	level.difficulty = level_settings.difficulty
	level.scene = packed_scene
	if !save_dialog.current_path.ends_with(".tres"):
		save_dialog.current_path += ".tres"
	ResourceSaver.save(level, save_dialog.current_path)

func _on_load_file_dialog_file_selected(path):
	var level: Resource = ResourceLoader.load(path)
	if level is Level:
		level_map.queue_free()
		level_settings.set_settings(level)
		level_map = Global.instanceNode(level.scene, self)
		level_map.set_mode(LevelPlayer.Mode.EDIT)

func _on_play_button_pressed():
	if is_editing():
		camera.enabled = false
		level_map.set_mode(LevelPlayer.Mode.PLAY)
	else:
		camera.enabled = true
		level_map.set_mode(LevelPlayer.Mode.EDIT)

func _on_save_button_pressed():
	save_dialog.show()

func _on_load_button_pressed():
	load_dialog.show()

func _on_quit_button_pressed():
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")
