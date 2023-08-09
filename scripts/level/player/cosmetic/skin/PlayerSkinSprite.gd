extends Sprite2D
class_name PlayerSkinSprite

func update_skin():
	texture = PlayerSkinManager.get_current_skin_texture()

func _ready():
	update_skin()
