extends Sprite2D
class_name PlayerHatSprite

func update_hat(override_hat_id: String = ""):
	var override_hat: PlayerHat = PlayerHatManager.get_hat(override_hat_id)
	if PlayerHatManager.has_a_hat() && override_hat == null:
		texture = PlayerHatManager.get_current_hat_texture()
	else:
		texture = override_hat.texture

func _ready():
	update_hat()
