extends Node

const HATS_DIR_PATH: String = "res://data/hats"

var current_hat: String = "no_hat"
var unlocked_hats: Array = ["no_hat"]
var hats: Array[PlayerHat]

func _ready() -> void:
	var resources: Array[ResourceElement] = DataLoader.new().load_data_in_dir(HATS_DIR_PATH, "hat")
	for resource in resources:
		if resource is PlayerHat:
			hats.append(resource)

func get_current_hat_texture() -> CompressedTexture2D:
	return get_hat(current_hat).texture

func get_hat(hat_id: String) -> PlayerHat:
	for hat in hats:
		if hat.id == hat_id:
			return hat
	return null

func unlock_hat(hat_id: String, special: bool = false) -> void:
	var hat: PlayerHat = get_hat(hat_id)
	if hat != null && !is_hat_unlocked(hat_id):
		unlocked_hats.append(hat_id)
		SaveManager.save()
	if special:
		PopUpFrame.set_on_pressed(func():SceneManager.change_scene("res://scenes/uis/ShopMenu.tscn"))
		PopUpFrame.pop(TranslationServer.translate("message.popup.unlocked_hat") % TranslationServer.translate(hat.name))

func is_hat_hidden(hat_id: String) -> bool:
	return get_hat(hat_id).is_hidden

func is_hat_unlocked(hat_id: String) -> bool:
	return unlocked_hats.has(hat_id)

func has_a_hat() -> bool:
	return !current_hat.is_empty()

func pick_random() -> String:
	var overall_chance: int = 0
	for hat in hats:
		if !hat.is_hidden:
			overall_chance += hat.chance
	var random_number = randi() % overall_chance
	var offset: int = 0
	for hat in hats:
		if !hat.is_hidden:
			if random_number < hat.chance + offset && hat.id != "no_hat":
				if is_hat_unlocked(hat.id):
					offset += hat.chance
				else:
					return hat.id
			else:
				offset += hat.chance
	return "no_hat"

func has_unlocked_unhiddens() -> bool:
	var unhidden_hats: int = hats\
		.filter(func(hat): return !hat.is_hidden)\
		.size()
	var unlocked_unhidden_hats: int = unlocked_hats\
		.filter(func(id): return !is_hat_hidden(id))\
		.size()
	return unhidden_hats <= unlocked_unhidden_hats

func has_unlocked_all() -> bool:
	return unlocked_hats.size() >= hats.size()
