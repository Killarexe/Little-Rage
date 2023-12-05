extends Control

@onready var logo_animation: AnimationPlayer = $CanvasLayer/Logo/AnimationPlayer
@onready var camera_animation: AnimationPlayer = $Camera2D/AnimationPlayer
@onready var logo: TextureRect = $CanvasLayer/Logo
@onready var spash_text = $CanvasLayer/SplashText

func _ready():
	get_tree().paused = false
	var easter_title_screen: bool = PlayerHatManager.has_unlocked_all() && PlayerSkinManager.has_unlocked_all()
	var animation: String = "start_menu"
	if easter_title_screen:
		MusicManager.play_music("title_screen_easter")
		logo.texture = load("res://assets/textures/ui/little_rage_logo_easter.png")
		animation = "start_menu_easter"
	else:
		MusicManager.play_music("title_screen")
	if Global.starting:
		Global.starting = false
		spash_text.visible = false
		logo_animation.play(animation)
		await logo_animation.animation_finished
		spash_text.visible = true
	camera_animation.play("scroll")
	logo_animation.play("logo_move")
	AchievementManager.unlock_achievement("start_the_game")
	DiscordRPCManager.update_rpc("In Main Menu", "basicicon", "In Main Menu")

func _on_settings_button_pressed():
	SceneManager.change_scene("res://scenes/uis/SettingsMenu.tscn")

func _on_play_button_pressed():
	SceneManager.change_scene("res://scenes/uis/SoloMenu.tscn")

func _on_multiplayer_button_pressed():
	SceneManager.change_scene("res://scenes/uis/MultiplayerSelection.tscn")

func _on_shop_button_pressed():
	SceneManager.change_scene("res://scenes/uis/CollectionsMenu.tscn")

func _on_level_editor_button_pressed():
	SceneManager.change_scene("res://scenes/uis/LevelEditorSelectionMenu.tscn")

func _on_quit_button_pressed():
	Global.save_game()
	get_tree().quit()
