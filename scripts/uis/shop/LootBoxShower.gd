extends ColorRect
class_name LootBoxShower

@onready var label: Label = $Label
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation: AnimationPlayer = $Sprite2D/AnimationPlayer

func unlock_random_cosmetic():
	var cosmetic: CosmeticElement = Global.loot_boxes.use_loot_box()
	print(TranslationServer.translate("ui.popup.unlocked_cosmetic") % TranslationServer.translate(cosmetic.name))
	label.text = TranslationServer.translate("ui.popup.unlocked_cosmetic") % TranslationServer.translate(cosmetic.name)
	sprite.texture = cosmetic.texture
	visible = true
	animation.play("pop_up")

func _on_close_button_pressed():
	animation.play_backwards("pop_up")
	await animation.animation_finished
	visible = false
