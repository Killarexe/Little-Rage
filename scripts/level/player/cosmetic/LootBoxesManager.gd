extends Node

var loot_box_count: int = 0

#chance: 0 - 1
func add_loot_box(chance: float, always: bool = false):
	var random: float = randf()
	if random <= chance || always:
		loot_box_count += 1
		SaveManager.save()
		PopUpFrame.set_on_pressed(func():SceneManager.change_scene("res://scenes/uis/CollectionsMenu.tscn"))
		PopUpFrame.pop_translated("message.popup.new_loot_box", load("res://assets/textures/ui/icons/chest.png"))

func has_loot_box() ->  bool:
	return loot_box_count > 0

func use_loot_box() -> CosmeticElement:
	if !has_loot_box():
		return null
	loot_box_count -= 1
	if randf() > 0.5:
		var skin_id: String = PlayerSkinManager.pick_random()
		PlayerSkinManager.unlock_skin(skin_id)
		return PlayerSkinManager.get_skin(skin_id)
	var hat_id: String = PlayerHatManager.pick_random()
	PlayerHatManager.unlock_hat(hat_id)
	return PlayerHatManager.get_hat(hat_id)
