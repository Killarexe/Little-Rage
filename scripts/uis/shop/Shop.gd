extends Control

@onready var loot_box_shower: LootBoxShower = $LootBoxShower
@onready var skins_selection: ItemList = $SkinsSelection
@onready var hats_selection: ItemList = $HatsSelection
@onready var loot_box_button: Button = $LootBoxButton
@export var player_skin: PlayerSkinSprite
@export var player_hat: PlayerHatSprite

var skin_ids: Array[String] = []
var hat_ids: Array[String] = []

func _ready():
	create_skin_items()
	create_hat_items()
	update_loot_box_button()
	MusicManager.play_music("shop")

func create_skin_items():
	skins_selection.clear()
	skin_ids.clear()
	for skin in PlayerSkinManager.skins:
		if PlayerSkinManager.is_skin_unlocked(skin.id):
			skin_ids.append(skin.id)
			skins_selection.add_item(TranslationServer.translate(skin.name), skin.texture)
			if PlayerSkinManager.current_skin == skin.id:
				skins_selection.select(skins_selection.item_count - 1)

func create_hat_items():
	hats_selection.clear()
	hat_ids.clear()
	for hat in PlayerHatManager.hats:
		if PlayerHatManager.is_hat_unlocked(hat.id):
			hat_ids.append(hat.id)
			hats_selection.add_item(TranslationServer.translate(hat.name), hat.texture)
			if PlayerHatManager.current_hat == hat.id:
				hats_selection.select(hats_selection.item_count - 1)

func _on_skins_selection_item_selected(index: int):
	PlayerSkinManager.current_skin = skin_ids[index]
	player_skin.update_skin()
	Global.save_game()

func _on_hats_selection_item_selected(index: int):
	PlayerHatManager.current_hat = hat_ids[index]
	player_hat.update_hat()
	Global.save_game()

func _on_loot_box_button_pressed():
	loot_box_shower.unlock_random_cosmetic()
	update_loot_box_button()
	create_skin_items()
	create_hat_items()

func update_loot_box_button():
	loot_box_button.disabled = !Global.loot_boxes.has_loot_box()
	loot_box_button.text = TranslationServer.translate("ui.shop.open_loot_box") % Global.loot_boxes.loot_box_count

func _on_quit_button_pressed():
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")
