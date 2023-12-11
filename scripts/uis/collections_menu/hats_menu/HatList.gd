extends ItemList

@export var player: PlayerMovement

var hats_ids: Array[String] = []

func _ready():
	max_columns = PlayerHatManager.hats.size() + 1
	for hat in PlayerHatManager.hats:
		if PlayerHatManager.is_hat_unlocked(hat.id):
			add_icon_item(hat.texture)
			hats_ids.append(hat.id)

func _on_item_selected(index: int):
	PlayerHatManager.current_hat = hats_ids[index]
	player.skin.update_hat()
	Global.save_game()
