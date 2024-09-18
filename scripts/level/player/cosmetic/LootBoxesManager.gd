extends Node

var loot_box_count: int = 0

#chance: 0 - 1
func add_loot_box(chance: float, always: bool = false) -> void:
	var random: float = randf()
	if random <= chance || always:
		loot_box_count += 1
		SaveManager.save()
		PopUpFrame.set_on_pressed(
			func():
				SceneManager.change_scene("res://scenes/uis/CollectionsMenu.tscn")
		)
		PopUpFrame.pop_translated("message.popup.new_loot_box", load("res://assets/textures/ui/icons/chest.png"))

func has_loot_box() ->  bool:
	return loot_box_count > 0

func use_loot_box() -> CosmeticElement:
	if !has_loot_box():
		return null
	loot_box_count -= 1
	var cosmetic_type: int = randi_range(0, 2)
	if cosmetic_type == 0:
		var skin_id: String = PlayerSkinManager.pick_random()
		PlayerSkinManager.unlock_skin(skin_id)
		return PlayerSkinManager.get_skin(skin_id)
	elif cosmetic_type == 1:
		var hat_id: String = PlayerHatManager.pick_random()
		PlayerHatManager.unlock_hat(hat_id)
		return PlayerHatManager.get_hat(hat_id)
	var particle_id: String = PlayerParticleManager.pick_random()
	PlayerParticleManager.unlock_particle(particle_id)
	return PlayerParticleManager.get_particle(particle_id)
