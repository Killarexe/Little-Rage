extends Sprite2D
class_name PlayerHatSprite

func update_hat(override_hat_id: String = "") -> void:
	var override_hat: PlayerHat = PlayerHatManager.get_hat(override_hat_id)
	if PlayerHatManager.has_a_hat() && override_hat == null:
		if !override_hat_id.is_empty():
			print_rich("[color=red][b]\tFailed to get hat '%s'[/b][/color]" % override_hat_id)
		texture = PlayerHatManager.get_current_hat_texture()
	else:
		texture = override_hat.texture

func _ready() -> void:
	update_hat()
