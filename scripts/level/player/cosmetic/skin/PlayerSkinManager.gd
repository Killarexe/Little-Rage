extends Node

const SKINS_DIR_PATH: String = "res://data/skins"

var current_skin: String = "default"
var unlocked_skins: Array = ["default"]
var skins: Array[PlayerSkin]

func _ready() -> void:
	var resources: Array[ResourceElement] = DataLoader.new().load_data_in_dir(SKINS_DIR_PATH, "skin")
	for resource in resources:
		if resource is PlayerSkin:
			skins.append(resource)

func get_current_skin_texture() -> CompressedTexture2D:
	return get_skin(current_skin).texture

func get_skin(skin_id: String) -> PlayerSkin:
	for skin in skins:
		if skin.id == skin_id:
			return skin
	return null

func unlock_skin(skin_id: String, special: bool = false) -> void:
	var skin: PlayerSkin = get_skin(skin_id)
	if skin != null && !is_skin_unlocked(skin_id):
		unlocked_skins.append(skin_id)
		SaveManager.save()
		if special:
			PopUpFrame.set_on_pressed(func():SceneManager.change_scene("res://scenes/uis/ShopMenu.tscn"))
			PopUpFrame.pop(TranslationServer.translate("message.popup.unlocked_skin") % TranslationServer.translate(skin.name), skin.texture)

func is_skin_hidden(skin_id: String) -> bool:
	return get_skin(skin_id).is_hidden

func is_skin_unlocked(skin_id: String) -> bool:
	return unlocked_skins.has(skin_id)

func pick_random() -> String:
	var overall_chance: int = 0
	for skin in skins:
		if !skin.is_hidden:
			overall_chance += skin.chance
	var random_number = randi() % overall_chance
	var offset: int = 0
	for skin in skins:
		if !skin.is_hidden:
			if random_number < skin.chance + offset:
				if is_skin_unlocked(skin.id):
						offset += skin.chance
				else:
					return skin.id
			else:
				offset += skin.chance
	return "default"

func has_unlocked_unhiddens() -> bool:
	var unhidden_skins: int = skins\
		.filter(func(skin): return !skin.is_hidden)\
		.size()
	var unlocked_unhidden_skins: int = unlocked_skins\
		.filter(func(id): return !is_skin_hidden(id))\
		.size()
	return unhidden_skins <= unlocked_unhidden_skins

func has_unlocked_all() -> bool:
	return unlocked_skins.size() >= skins.size()
