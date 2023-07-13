class_name LootBoxesManager

var loot_box_count: int = 0

#chance: 0 - 1
func add_loot_box(chance: float):
	if randf() >= chance:
		loot_box_count += 1
		Global.save_game()
		PopUpFrame.pop_translated("ui.popup.new_loot_box")

func has_loot_box() ->  bool:
	return loot_box_count > 0

func use_loot_box() -> Texture2D:
	if !has_loot_box():
		return null
	loot_box_count -= 1
	if randf() > 0.5:
		var skin_id: String = PlayerSkinManager.pick_random()
		PlayerSkinManager.unlock_skin(skin_id)
		return PlayerSkinManager.get_skin(skin_id).texture
	var hat_id: String = PlayerHatManager.pick_random()
	PlayerHatManager.unlock_hat(hat_id)
	return PlayerHatManager.get_hat(hat_id).texture
