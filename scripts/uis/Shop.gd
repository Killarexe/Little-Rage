extends Control

@onready var skins_selection: ItemList = $SkinsSelection
@onready var hats_selection: ItemList = $HatsSelection

var skin_ids: Array[String] = []
var hat_ids: Array[String] = []

func _ready():
	create_skin_items()
	#create_hat_items()

func create_skin_items():
	for skin in PlayerSkinManager.skins:
		if !PlayerSkinManager.is_skin_hidden(skin.id):
			skin_ids.append(skin.id)
			if PlayerSkinManager.is_skin_unlocked(skin.id):
				skins_selection.add_item(skin.id, skin.texture)
				if PlayerSkinManager.current_skin == skin.id:
					skins_selection.select(skin_ids.size() - 1)
			else:
				var black_texture: Image = Image.new()
				black_texture.resize(16, 32)
				black_texture.fill(Color.BLACK)
				skins_selection.add_item(skin.id, ImageTexture.create_from_image(black_texture))

func create_hat_items():
	pass
