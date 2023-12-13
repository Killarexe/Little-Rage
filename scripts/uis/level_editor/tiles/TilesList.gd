extends ItemList
class_name TilesList
const TILES_DIR: String = "res://data/tiles/"

var editor_tiles: Array[EditorTile]

func _ready():
	for element in DataLoader.new().load_data_in_dir(TILES_DIR, "EditorTile"):
		if element is EditorTile:
			editor_tiles.append(element)

func create_list(atlas: CompressedTexture2D):
	for tile in editor_tiles:
		for tile_position in tile.tile_dictionary.keys():
				var tile_id: Vector2i = tile.tile_dictionary.get(tile_position)
				var atlas_coord: Vector2i = tile_id * Vector2i(16, 16)
				var region: Rect2i = tile.icon_region
				if tile.icon_region == Rect2i(-1, -1, -1, -1):
					region = Rect2i(atlas_coord, Vector2i(16, 16))
				add_icon_item(ImageTexture.create_from_image(atlas.get_image().get_region(region)))
				break;

func get_selected_tile_id(index: int) -> Vector2:
	return editor_tiles[index].tile_dictionary.get(Vector2i(0, 0))
