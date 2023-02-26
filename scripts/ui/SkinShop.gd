extends Control

var selectedSkin = 0
onready var cost = $Cost
onready var coins = $Coins
onready var sprite = $Sprite
onready var buyButton = $Buttons/BuyButton

func _ready():
	updateSprite()
	Global.play_music(3)

func _on_Back_pressed():
	SceneTransition.change_scene("res://scenes/ui/MainMenu.tscn")

func _on_LeftSelect_pressed():
	if(selectedSkin != 0):
		selectedSkin -= 1
		updateSprite()

func _on_RightSelect_pressed():
	if OS.is_debug_build():
		if(selectedSkin != Global.skins.size() - 1):
			selectedSkin += 1
			updateSprite()
	else:
		if(selectedSkin != Global.skins.size() - 3):
			selectedSkin += 1
			updateSprite()

func _on_BuyButton_pressed():
	if(!Global.unlockedSkins.has(selectedSkin)):
		Global.unlockSkin(selectedSkin)
	else:
		Global.currentSkin = Global.skins[selectedSkin]
	updateSprite()

func updateSprite():
	coins.text = "Coins: " + str(Global.coins)
	sprite.texture = Global.skins[selectedSkin][0]
	cost.text = "Cost: " + str(Global.skins[selectedSkin][1]) + " coins"
	buyButton.text = "Buy"
	if(Global.unlockedSkins.has(selectedSkin)):
		buyButton.text = "Equip"
	if(Global.currentSkin == Global.skins[selectedSkin]):
		buyButton.text = "Equiped"
	
	if(Global.skins[selectedSkin][1] > Global.coins && !Global.unlockedSkins.has(selectedSkin)) || Global.currentSkin == Global.skins[selectedSkin]:
		buyButton.disabled = true
	else:
		buyButton.disabled = false
