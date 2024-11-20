extends Button
class_name TilesButton

@export var level: LevelPlayer
@export var tiles_list: TilesList

func _ready() -> void:
	if !tiles_list.is_node_ready():
		await tiles_list.ready
	tiles_list.on_selected.connect(update_tiles_button_texture)
	update_tiles_button_texture(tiles_list.editor_tiles[0])

func update_tiles_button_texture(tile: EditorTile):
		icon = tile.get_icon(level)
