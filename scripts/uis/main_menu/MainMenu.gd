extends Control

@onready var logo_animation: AnimationPlayer = $CanvasLayer/Logo/AnimationPlayer
@onready var camera_animation: AnimationPlayer = $Camera2D/AnimationPlayer
@onready var logo: TextureRect = $CanvasLayer/Logo
@onready var spash_text = $CanvasLayer/SplashText
@onready var level: LevelPlayer = $TitleScreenLevel

func _ready() -> void:
	get_tree().paused = false
	var easter_title_screen: bool = Game.has_unlocked_unhiddens()
	var animation: String = "start_menu"
	var music: String = "title_screen"
	var tilemap_texture: Texture2D = LevelManager.get_random_tilemap_texture()
	level.ground.tile_set.get_source(1).texture = tilemap_texture
	level.background.tile_set.get_source(1).texture = tilemap_texture
	
	if Game.current_event == Game.Event.CHRISTMAS:
		music = "title_screen_christmas_special"
	elif Game.current_event == Game.Event.HALLOWEEN:
		music = "title_screen_halloween_special"
	elif easter_title_screen:
		music = "title_screen_easter"
	
	if easter_title_screen:
		logo.texture = load("res://assets/textures/ui/little_rage_logo_easter.png")
		animation = "start_menu_easter"
	MusicManager.play_music(music)
	
	if Game.starting:
		Game.starting = false
		spash_text.visible = false
		logo_animation.play(animation)
		await logo_animation.animation_finished
		spash_text.visible = true
	camera_animation.play("scroll")
	logo_animation.play("logo_move")
	AchievementManager.unlock_achievement("start_the_game")

func _on_settings_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/uis/SettingsMenu.tscn")

func _on_play_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/uis/SoloMenu.tscn")

func _on_shop_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/uis/CollectionsMenu.tscn")

func _on_level_editor_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/uis/LevelEditorSelectionMenu.tscn")

func _on_quit_button_pressed() -> void:
	SaveManager.save()
	get_tree().quit()
