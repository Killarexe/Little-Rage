extends Control

@onready var skins_selection: ItemList = $SkinsSelection
@onready var hats_selection: ItemList = $HatsSelection
@export var player_skin: PlayerSkinSprite
#@export var player_hat: PlayerHatSprite

var skin_ids: Array[String] = []
var hat_ids: Array[String] = []

func _ready():
	create_skin_items()
	create_hat_items()

func create_skin_items():
	for skin in PlayerSkinManager.skins:
		if PlayerSkinManager.is_skin_unlocked(skin.id):
			skin_ids.append(skin.id)
			skins_selection.add_item(skin.id, skin.texture)
			if PlayerSkinManager.current_skin == skin.id:
				skins_selection.select(skin_ids.size() - 1)

func create_hat_items():
	hat_ids.append("")
	hats_selection.add_item("ui.shop.no_hat")
	if PlayerHatManager.current_hat.is_empty():
		skins_selection.select(0)
	for hat in PlayerHatManager.hats:
		if PlayerHatManager.is_hat_unlocked(hat.id):
			hat_ids.append(hat.id)
			hats_selection.add_item(hat.id, hat.texture)
			if PlayerHatManager.current_hat == hat.id:
				skins_selection.select(hat_ids.size() - 1)

func _on_skins_selection_item_selected(index: int):
	PlayerSkinManager.current_skin = skin_ids[index]
	player_skin.update_skin()
	Global.save_game()

func _on_hats_selection_item_selected(index: int):
	PlayerSkinManager.current_hat = hat_ids[index]
	#player_hat.update_hat()
	Global.save_game()
