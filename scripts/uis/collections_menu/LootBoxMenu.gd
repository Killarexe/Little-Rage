extends Control
class_name LootBoxMenu

@onready var cosmetic_texture: TextureRect = $CosmeticTexture
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var next_button: Button = $Buttons/NextBoxButton

func open():
	animation_player.play("entry")
	animation_player.queue("show")

func update_texture():
	var cosmetic: CosmeticElement = LootBoxesManager.use_loot_box()
	cosmetic_texture.texture = cosmetic.texture

func update_buttons():
	next_button.visible = LootBoxesManager.has_loot_box()

func spawn_particles():
	Game.instanceNodeAtPos(load("res://scenes/instances/BigPartyParticle.tscn"), self, Vector2(1280.0 / 2.0, 720.0 / 2.0))

func _on_next_box_button_pressed():
	if !animation_player.is_playing():
		animation_player.play("show")

func _on_back_button_pressed():
	if !animation_player.is_playing():
		animation_player.play("back")
