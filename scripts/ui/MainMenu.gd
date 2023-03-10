extends Control

@export var splashes: Array = [] # (Array, String)
@onready var splash = $CanvasLayer/Splash

func _ready():
	Global.play_music(1)
	$CanvasLayer/Splash/AnimationPlayer.play("splash_animation")
	$CanvasLayer/Splash.text = splashes[randi_range(0, splashes.size() - 1)]

func _on_SinglePlayerButton_pressed():
	Global.settings_clicked = 0
	SceneTransition.change_scene_to_file("res://scenes/ui/LevelSelector.tscn")

func _on_MultiPlayerButton_pressed():
	Global.settings_clicked = 0
	SceneTransition.change_scene_to_file("res://scenes/ui/MultiplayerTypeSelection.tscn")

func _on_OptionsButton_pressed():
	Global.settings_clicked = 0
	SceneTransition.change_scene_to_file("res://scenes/ui/LevelEditor.tscn")

func _on_QuitButton_pressed():
	Global.settings_clicked = 0
	if(Input.is_action_pressed("ui_left")):
		SceneTransition.change_scene_to_file("res://scenes/instances/Server.tscn")
		pass
	get_tree().quit()

func _on_ShopButton_pressed():
	$Camera2D.enabled = true
	$Camera2D/AnimationPlayer.play("zoom")
	await $Camera2D/AnimationPlayer.animation_finished
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
		$TitleLevel.get_node("Player").global_position.x = 205
		$TitleLevel.get_node("Player").global_position.y = 916
		selectedSkin = Global.currentSkin
		updateSprite()

func updateSprite():
	$CanvasLayer/Coins.text = "Coins: " + str(Global.coins)
	$TitleLevel.get_node("Player/Sprite2D").texture = Global.skins[selectedSkin][0]
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
	Global.settings_clicked += 1
	if Global.settings_clicked >= 5:
		$CanvasLayer/Easter.visible = true
		Global.play_music(4)
		await get_tree().create_timer(13.5).timeout
		Global.play_music(1)
		$CanvasLayer/Easter.visible = false
		Global.settings_clicked = 0
		return
	SceneTransition.change_scene_to_file("res://scenes/ui/Settings.tscn")

func _on_QuitShopButton_pressed():
	$Camera2D/AnimationPlayer.play_backwards("zoom")
	await $Camera2D/AnimationPlayer.animation_finished
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
