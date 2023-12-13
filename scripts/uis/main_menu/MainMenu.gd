extends Control

@onready var logo_animation: AnimationPlayer = $CanvasLayer/Logo/AnimationPlayer
@onready var camera_animation: AnimationPlayer = $Camera2D/AnimationPlayer
@onready var logo: TextureRect = $CanvasLayer/Logo
@onready var spash_text = $CanvasLayer/SplashText

func _ready():
	get_tree().paused = false
	var easter_title_screen: bool = PlayerHatManager.has_unlocked_unhiddens() && PlayerSkinManager.has_unlocked_unhiddens()
	var music: String = "title_screen"
	var animation: String = "start_menu"
	
	var date = Time.get_datetime_dict_from_system()
	var day: int = date["day"]
	var month: int = date["month"]
	if (day >= 23 && day <= 26) && month == 12:
		music = "title_screen_christmas_special"
		RenderingServer.set_default_clear_color(Color.hex(0x80cff7FF))
		AchievementManager.unlock_achievement("christmas_event")
	elif (day == 30 || day == 31) && month == 10:
		music = "title_screen_halloween_special"
		RenderingServer.set_default_clear_color(Color.hex(0x1b1c28FF))
		AchievementManager.unlock_achievement("halloween_event")
	elif easter_title_screen:
		music = "title_screen_easter"
	
	if easter_title_screen:
		logo.texture = load("res://assets/textures/ui/little_rage_logo_easter.png")
		animation = "start_menu_easter"
	MusicManager.play_music(music)
	
	if Global.starting:
		Global.starting = false
		spash_text.visible = false
		logo_animation.play(animation)
		await logo_animation.animation_finished
		spash_text.visible = true
	camera_animation.play("scroll")
	logo_animation.play("logo_move")
	AchievementManager.unlock_achievement("start_the_game")

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
