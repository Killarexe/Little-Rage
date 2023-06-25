extends Sprite2D
class_name PlayerHatSprite

func update_hat():
	texture = PlayerHatManager.get_current_hat_texture()

func _ready():
	update_hat()
