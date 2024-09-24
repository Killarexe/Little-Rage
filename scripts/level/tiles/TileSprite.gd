extends Sprite2D
class_name TileSprite

func _ready() -> void:
	if texture is AtlasTexture:
		texture.atlas = LevelManager.get_tilemap_texture()
