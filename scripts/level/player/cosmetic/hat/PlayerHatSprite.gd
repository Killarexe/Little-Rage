extends Sprite2D
class_name PlayerHatSprite

func update_hat():
	if PlayerHatManager.has_a_hat():
		texture = PlayerHatManager.get_current_hat_texture()

func _ready():
	update_hat()
