extends Control

export(Array, String) var splashes = []
var images = [load("res://textures/backgrounds/Image1.png"), load("res://textures/backgrounds/Image2.png"), load("res://textures/backgrounds/Image3.png")]

onready var splash = $CanvasLayer/Splash

func _ready():
	Global.play_music(1)
	var random = RandomNumberGenerator.new()
	random.randomize()
	splash.text = splashes[random.randi_range(0, splashes.size()-1)]
	if(random.randi_range(0, 100) >= 95):
		$CanvasLayer/Title.text = "Little Game"
	$CanvasLayer/Splash/AnimationPlayer.play("splash_animation")

func _on_SinglePlayerButton_pressed():
	SceneTransition.change_scene("res://scenes/ui/LevelSelector.tscn")

func _on_MultiPlayerButton_pressed():
	SceneTransition.change_scene("res://scenes/ui/MultiplayerTypeSelection.tscn")

func _on_OptionsButton_pressed():
	SceneTransition.change_scene("res://scenes/ui/LevelEditor.tscn")

func _on_QuitButton_pressed():
	if(Input.action_press("ui_left")):
		SceneTransition.change_scene("res://scenes/instances/Server.tscn")
		pass
	get_tree().quit()

func _on_ShopButton_pressed():
	#SceneTransition.change_scene("res://scenes/ui/SkinShop.tscn")
	$Camera2D.current = true
	$Camera2D/AnimationPlayer.play("zoom")
	yield($Camera2D/AnimationPlayer, "animation_finished")
	show_shop(true)

var selectedSkin: int = 0

func show_shop(show: bool) -> void:
	$CanvasLayer/Coins.visible = show
	$CanvasLayer/Cost.visible = show
	$Buttons/BuyButton.visible = show
	$Buttons/QuitShopButton.visible = show
	$Buttons/NextButton.visible = show
	$Buttons/PreviousButton.visible = show
	if(show):
		selectedSkin = Global.currentSkin
		updateSprite()

func updateSprite():
	$CanvasLayer/Coins.text = "Coins: " + str(Global.coins)
	$TitleLevel.get_node("Player/Sprite").texture = Global.skins[selectedSkin][0]
	$CanvasLayer/Cost.text = "Cost: " + str(Global.skins[selectedSkin][1]) + " coins"
	$Buttons/BuyButton.text = "Buy"
	if(Global.unlockedSkins.has(selectedSkin)):
		$Buttons/BuyButton.text = "Equip"
	if(Global.currentSkin == selectedSkin):
		$Buttons/BuyButton.text = "Equiped"
	
	if(Global.skins[selectedSkin][1] > Global.coins && !Global.unlockedSkins.has(selectedSkin)) || Global.currentSkin == selectedSkin:
		$Buttons/BuyButton.disabled = true
	else:
		$Buttons/BuyButton.disabled = false

func _on_OptionButton_pressed():
	SceneTransition.change_scene("res://scenes/ui/Settings.tscn")

func _on_QuitShopButton_pressed():
	$Camera2D/AnimationPlayer.play_backwards("zoom")
	show_shop(false)

func _on_BuyButton_pressed():
	if(!Global.unlockedSkins.has(selectedSkin)):
		Global.unlockSkin(selectedSkin)
	else:
		Global.currentSkin = selectedSkin
		Global.saveGame()
	updateSprite()

func _on_PreviousButton_pressed():
	if OS.is_debug_build():
		if(selectedSkin != Global.skins.size() - 1):
			selectedSkin += 1
			updateSprite()
	else:
		if(selectedSkin != Global.skins.size() - 3):
			selectedSkin += 1
			updateSprite()

func _on_NextButton_pressed():
	if(selectedSkin != 0):
		selectedSkin -= 1
		updateSprite()
