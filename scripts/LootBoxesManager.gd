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

func use_loot_box():
	if !has_loot_box():
		return
	if randf() > 0.5:
		PlayerSkinManager.unlock_skin(PlayerSkinManager.pick_random())
	else:
		PlayerHatManager.unlock_hat(PlayerHatManager.pick_random())
