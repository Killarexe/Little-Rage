extends Button
class_name TilesButton

@export var tiles_list: TilesList
@export var animation_player: AnimationPlayer
@export var level: LevelPlayer

func _ready() -> void:
	tiles_list.on_selected.connect(update_button_texture)
	pressed.connect(on_pressed)
	update_button_texture(tiles_list.editor_tiles[0])

func on_pressed():
	if tiles_list.visible:
		animation_player.play_backwards("appear")
	else:
		animation_player.play("appear")

func update_button_texture(tile: EditorTile):
	for tile_position in tile.tile_dictionary.keys():
		var tile_id: Vector2i = tile.tile_dictionary.get(tile_position)
		var atlas_coord: Vector2i = tile_id * Vector2i(16, 16)
		var region: Rect2i = tile.icon_region
		if tile.icon_region == Rect2i(-1, -1, -1, -1):
			region = Rect2i(atlas_coord, Vector2i(16, 16))
		icon = ImageTexture.create_from_image(level.ground.tile_set.get_source(1).texture.get_image().get_region(region))
