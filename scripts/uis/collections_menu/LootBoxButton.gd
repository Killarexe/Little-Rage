extends Button

@onready var circle: TextureRect = $Circle
@onready var loot_box_count: Label = $Circle/LootBoxCount

func _ready():
	update_button()

func update_button():
	disabled = !Global.loot_boxes.has_loot_box()
	circle.visible = Global.loot_boxes.has_loot_box()
	if Global.loot_boxes.loot_box_count < 100:
		loot_box_count.text = str(Global.loot_boxes.loot_box_count)
	else:
		loot_box_count.text = "99+"
