extends Node

const HATS_DIR_PATH: String = "res://data/hats"

var current_hat: String = "no_hat"
var unlocked_hats: Array = ["no_hat"]
var unhidden_hats: Array = []
var hats: Array[PlayerHat]

func _ready():
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

func unlock_hat(hat_id: String):
	if get_hat(hat_id) != null && !is_hat_unlocked(hat_id):
		unlocked_hats.append(hat_id)
		Global.save_game()

func unhide_hat(hat_id: String):
	var hat: PlayerHat = get_hat(hat_id)
	if hat != null:
		if hat.is_hidden && !unhidden_hats.has(hat_id):
			unhidden_hats.append(hat_id)
			Global.save_game()

func is_hat_hidden(hat_id: String) -> bool:
	return get_hat(hat_id).is_hidden && !unhidden_hats.has(hat_id)

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
				return hat.id
			else:
				offset += hat.chance
	return pick_random()
