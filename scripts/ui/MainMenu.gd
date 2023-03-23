extends Control

@onready var camera = $Camera2D
@export var splashes: Array = [] # (Array, String)
@onready var easter = $CanvasLayer/Easter
@onready var splash = $CanvasLayer/Splash
@onready var cost_label = $CanvasLayer/Cost
@onready var coins_label = $CanvasLayer/Coins
@onready var shop_buttons = $Buttons/ShopButtons
@onready var logo_image = $CanvasLayer/TextureRect
@onready var player = $TitleLevel.get_node("Player")
@onready var buy_button = $Buttons/ShopButtons/BuyButton
@onready var next_button = $Buttons/ShopButtons/NextButton
@onready var camera_animation_player = $Camera2D/AnimationPlayer
@onready var player_skin = $TitleLevel.get_node("Player/Sprite2D")
@onready var previous_button = $Buttons/ShopButtons/PreviousButton
@onready var splash_animation_player = $CanvasLayer/Splash/AnimationPlayer
var shop_button_pressed: int = 0
var selectedSkin: int = 0

func _ready():
	MusicPlayer.play_music(1)
	splash_animation_player.play("splash_animation")
	splash.text = splashes[randi_range(0, splashes.size() - 1)]
	logo_image.texture = load("res://textures/uis/little_rage_logo.png")

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
	camera.enabled = true
	camera_animation_player.play("zoom")
	await camera_animation_player.animation_finished
	show_shop(true)
	shop_button_pressed += 1
	if shop_button_pressed >= 10:
		SkinManager.unhide_skin(6)

func show_shop(showing: bool) -> void:
	coins_label.visible = showing
	cost_label.visible = showing
	shop_buttons.visible = showing
	if(showing):
		player.global_position.x = 205
		player.global_position.y = 916
		selectedSkin = SkinManager.current_skin
		updateSprite()

func updateSprite():
	coins_label.text = "Coins: " + str(Global.coins)
	player_skin.texture = SkinManager.get_skin_texture(selectedSkin)
	cost_label.text = "Cost: " + str(SkinManager.get_skin_cost(selectedSkin)) + " coins"
	buy_button.text = "Buy"
	if(SkinManager.is_skin_unlocked(selectedSkin)):
		buy_button.text = "Equip"
	if(SkinManager.current_skin == selectedSkin):
		buy_button.text = "Equiped"
	
	buy_button.disabled = (
		(
			SkinManager.get_skin_cost(selectedSkin) > Global.coins &&
			!SkinManager.is_skin_unlocked(selectedSkin)
		)
		|| SkinManager.current_skin == selectedSkin
	)

func _on_OptionButton_pressed():
	Global.settings_clicked += 1
	if Global.settings_clicked >= 5:
		easter.visible = true
		Global.play_music(4)
		await get_tree().create_timer(13.5).timeout
		Global.play_music(1)
		easter.visible = false
		Global.settings_clicked = 0
		return
	SceneTransition.change_scene_to_file("res://scenes/ui/Settings.tscn")

func _on_QuitShopButton_pressed():
	camera_animation_player.play_backwards("zoom")
	await camera_animation_player.animation_finished
	show_shop(false)

func _on_BuyButton_pressed():
	if(!SkinManager.is_skin_unlocked(selectedSkin)):
		SkinManager.unlock_skin(selectedSkin)
	else:
		SkinManager.current_skin = selectedSkin
		Global.saveGame()
	updateSprite()

func _on_PreviousButton_pressed():
	for i in range(1, SkinManager.SKINS_DEFAULT.size()):
		if selectedSkin + i < SkinManager.SKINS_DEFAULT.size():
			if !SkinManager.is_hidden(selectedSkin + i):
				selectedSkin += i
				updateSprite()
				break;
		else:
			break

func _on_NextButton_pressed():
	for i in range(1, SkinManager.SKINS_DEFAULT.size()):
		if selectedSkin - i >= 0:
			if !SkinManager.is_hidden(selectedSkin - i):
				selectedSkin -= i
				updateSprite()
				break;
		else:
			break
