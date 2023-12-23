extends ItemList
class_name HatList

@export var player: PlayerMovement

var hats_ids: Array[String] = []

func _ready():
	set_hat_items()

func set_hat_items():
	clear()
	max_columns = PlayerHatManager.hats.size() + 1
	for hat in PlayerHatManager.hats:
		if PlayerHatManager.is_hat_unlocked(hat.id):
			if hat.id != "no_hat":
				add_icon_item(hat.texture)
			else:
				add_icon_item(load("res://assets/textures/ui/icons/no_hat.png"))
			hats_ids.append(hat.id)

func _on_item_selected(index: int):
	PlayerHatManager.current_hat = hats_ids[index]
	player.skin.update_hat()
	SaveManager.save()
