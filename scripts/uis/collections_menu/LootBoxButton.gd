extends Button

@onready var circle: TextureRect = $Circle
@onready var loot_box_count: Label = $Circle/LootBoxCount

func _ready():
	update_button()

func update_button():
	var all_unhiddens_unlocked: bool = Game.has_unlocked_unhiddens()
	disabled = !LootBoxesManager.has_loot_box() || all_unhiddens_unlocked
	circle.visible = LootBoxesManager.has_loot_box()
	if LootBoxesManager.loot_box_count < 100:
		loot_box_count.text = str(LootBoxesManager.loot_box_count)
	else:
		loot_box_count.text = "99+"
