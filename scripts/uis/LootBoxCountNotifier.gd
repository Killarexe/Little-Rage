extends TextureRect

@export var count_label: Label

func _ready():
	var loot_box_count: int = LootBoxesManager.loot_box_count
	visible = loot_box_count > 0 && !Game.has_unlocked_unhiddens()
	if loot_box_count > 99:
		count_label.text = "99+"
	else:
		count_label.text = str(loot_box_count)
