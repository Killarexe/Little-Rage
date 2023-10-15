extends ItemList

@export var player_skin: PlayerSkinSprite

var hats_ids: Array[String] = []

func _ready():
	max_columns = PlayerHatManager.hats.size() + 1
	for hat in PlayerHatManager.hats:
		var unlocked: bool = PlayerHatManager.is_hat_unlocked(hat.id)
		if !(hat.is_hidden && !unlocked):
			add_icon_item(hat.texture, unlocked)
			hats_ids.append(hat.id)

func _on_item_selected(index: int):
	PlayerHatManager.current_hat = hats_ids[index]
	player_skin.update_hat()
	Global.save_game()
