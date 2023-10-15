extends Sprite2D
class_name PlayerSkinSprite

@onready var hat_sprite: PlayerHatSprite = $PlayerHatSprite

func update_skin():
	texture = PlayerSkinManager.get_current_skin_texture()

func update_hat():
	hat_sprite.update_hat()

func _ready():
	update_skin()
