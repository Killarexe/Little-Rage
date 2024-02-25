extends ItemList
class_name SkinList

@export var player: PlayerDummyComponent

var skin_ids: Array[String] = []

func _ready():
	set_item_skins()

func set_item_skins():
	clear()
	max_columns = PlayerSkinManager.skins.size() + 1
	for skin in PlayerSkinManager.skins:
		if PlayerSkinManager.is_skin_unlocked(skin.id):
			add_icon_item(skin.texture)
			skin_ids.append(skin.id)

func _on_item_selected(index: int):
	PlayerSkinManager.current_skin = skin_ids[index]
	player.player_skin.update_skin()
	SaveManager.save()
