extends ItemList

@export var player: PlayerMovement

var skin_ids: Array[String] = []

func _ready():
	max_columns = PlayerSkinManager.skins.size() + 1
	for skin in PlayerSkinManager.skins:
		if PlayerSkinManager.is_skin_unlocked(skin.id):
			add_icon_item(skin.texture)
			skin_ids.append(skin.id)

func _on_item_selected(index: int):
	PlayerSkinManager.current_skin = skin_ids[index]
	player.skin.update_skin()
	SaveManager.save()
