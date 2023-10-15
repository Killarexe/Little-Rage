extends ItemList

@export var player_skin: PlayerSkinSprite

var skin_ids: Array[String] = []

func _ready():
	max_columns = PlayerSkinManager.skins.size() + 1
	for skin in PlayerSkinManager.skins:
		var unlocked: bool = PlayerSkinManager.is_skin_unlocked(skin.id)
		if !(skin.is_hidden && !unlocked):
			add_icon_item(skin.texture, unlocked)
			skin_ids.append(skin.id)

func _on_item_selected(index: int):
	PlayerSkinManager.current_skin = skin_ids[index]
	player_skin.update_skin()
	Global.save_game()
