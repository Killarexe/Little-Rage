extends Node
class_name CosmeticManager

var current_cosmetic: String = ""
var unlocked_cosmetics: Array[String] = []
var cosmetics: Array[CosmeticElement] = []
var overall_chance: int = 0

func _ready() -> void:
	current_cosmetic = get_default_cosmetic()
	unlocked_cosmetics.append(get_default_cosmetic())
	load_cosmetics()
	
	var overall_chance: int = 0
	for cosmetic in cosmetics:
		if !cosmetic.is_hidden:
			overall_chance += cosmetic.chance

func load_cosmetics() -> void:
	var resources: Array[ResourceElement] = DataLoader.new().load_data_in_dir(get_dir(), get_cosmetic_name())
	for resource in resources:
		if resource is CosmeticElement:
			cosmetics.append(resource)

func get_current_cosmetic() -> CosmeticElement:
	return get_cosmetic(current_cosmetic)

func get_cosmetic(id: String) -> CosmeticElement:
	for cosmetic in cosmetics:
		if cosmetic.id == id:
			return cosmetic
	return null

func unlock_cosmetic(id: String, notify: bool = false) -> void:
	if !unlocked_cosmetics.has(id) && get_cosmetic(id) != null:
		unlocked_cosmetics.append(id)

func pick_random() -> String:
	var random_number = randi() % overall_chance
	var offset: int = 0
	for cosmetic in cosmetics:
		if !cosmetic.is_hidden:
			if random_number < cosmetic.chance + offset:
				if is_cosmetic_unlocked(cosmetic.id):
						offset += cosmetic.chance
				else:
					return cosmetic.id
			else:
				offset += cosmetic.chance
	return get_default_cosmetic()

func is_cosmetic_hidden(id: String) -> bool:
	return !(get_cosmetic(id).is_hidden && !is_cosmetic_unlocked(id))

func is_cosmetic_unlocked(id: String) -> bool:
	return unlocked_cosmetics.has(id)

func get_cosmetic_name() -> String:
	return "something"

func get_cosmetic_type() -> String:
	return "something"

func get_dir() -> String:
	return "res://data/" + get_cosmetic_name()

func get_default_cosmetic() -> String:
	return "default"

func has_unlocked_all() -> bool:
	return cosmetics.size() <= unlocked_cosmetics.size()
