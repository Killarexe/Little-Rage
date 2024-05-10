extends Sprite2D
class_name PlayerSkinSprite

func update_skin(override_skin_id: String = ""):
	var override_skin: PlayerSkin = PlayerSkinManager.get_skin(override_skin_id)
	if override_skin == null:
		if !override_skin_id.is_empty():
			print_rich("[color=red][b]\tFailed to get skin '%s'[/b][/color]" % override_skin_id)
		texture = PlayerSkinManager.get_current_skin_texture()
	else:
		texture = override_skin.texture

func _ready():
	update_skin()
