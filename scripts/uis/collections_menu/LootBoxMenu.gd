extends Control
class_name LootBoxMenu

@export var cosmetic_texture: TextureRect
@export var cosmetic_label: Label
@export var animation_player: AnimationPlayer
@export var next_button: Button

@export var skin_list: SkinList
@export var hat_list: HatList
@export var particle_menu: ParticlesMenu

func open():
	animation_player.play("entry")
	animation_player.queue("show")

func update_texture():
	var cosmetic: CosmeticElement = LootBoxesManager.use_loot_box()
	if cosmetic != null:
		cosmetic_texture.texture = cosmetic.get_texture_or_default()
		skin_list.set_item_skins()
		hat_list.set_hat_items()
		particle_menu.load_particles()
		cosmetic_label.text = TranslationServer.translate("label.unlocked_cosmetic") + ": " + TranslationServer.translate(cosmetic.name)

func update_buttons():
	next_button.visible = LootBoxesManager.has_loot_box()

func spawn_particles():
	Game.instanceNodeAtPos(load("res://scenes/bundles/particles/BigPartyParticle.tscn"), self, Vector2(1280.0 / 2.0, 720.0 / 2.0))

func _on_next_box_button_pressed():
	if !animation_player.is_playing():
		animation_player.play("show")

func _on_back_button_pressed():
	if !animation_player.is_playing():
		animation_player.play("back")
