extends Control
class_name MainCollectionMenu

const UNLOCK_ALL_CHEAT_CODE: Array[String] = ["jump", "jump", "down", "down", "left", "right", "left", "right", "left_click", "right_click"]
var cheat_code_index: int = 0

@onready var animation_player: AnimationPlayer = $SelectButtons/AnimationPlayer
@onready var camera_animation_player: AnimationPlayer = $"../../DefaultLevel/PlayerDummy/PlayerViewer/AnimationPlayer"
@onready var loot_box_menu: LootBoxMenu = $LootBoxMenu
@onready var jukebox_button: Button = $SelectButtons/JukeboxButton

func _ready():
	var has_unlocked_all: bool = Game.has_unlocked_unhiddens()
	if has_unlocked_all:
		MusicManager.play_music("collections_menu_easter")
	else:
		MusicManager.play_music("collections_menu")
	jukebox_button.visible = has_unlocked_all

func _input(event: InputEvent):
	if (event is InputEventKey || event is InputEventMouseButton) && !event.is_released():
		if event.is_action_pressed(UNLOCK_ALL_CHEAT_CODE[cheat_code_index]):
			if cheat_code_index >= UNLOCK_ALL_CHEAT_CODE.size() - 1:
				cheat_code_index = 0
				for skin in PlayerSkinManager.skins:
					PlayerSkinManager.unlock_skin(skin.id)
				for hat in PlayerHatManager.hats:
					PlayerHatManager.unlock_hat(hat.id)
				PopUpFrame.pop("Cheat Code: Unlock all!")
			else:
				cheat_code_index += 1
		else: 
			cheat_code_index = 0

func _on_skins_button_pressed():
	set_menu_to(0)

func _on_hats_button_pressed():
	set_menu_to(1)

func _on_particles_button_pressed():
	set_menu_to(2)

func set_menu_to(menu: int):
	animation_player.play_backwards("enter")
	await animation_player.animation_finished
	visible = false
	match menu:
		0:
			camera_animation_player.play("zoom_skin")
			$"../SkinsMenu".visible = true
		1:
			camera_animation_player.play("zoom_hat")
			$"../HatsMenu".visible = true
		2:
			camera_animation_player.play("zoom_particles")
			$"../ParticlesMenu".visible = true

func _on_back_button_pressed():
	animation_player.play_backwards("enter")
	await animation_player.animation_finished
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")

func _on_achievements_button_pressed():
	animation_player.play_backwards("enter")
	await animation_player.animation_finished
	SceneManager.change_scene("res://scenes/uis/AchievementMenu.tscn")

func _on_loot_box_button_pressed():
	loot_box_menu.open()

func _on_jukebox_button_pressed():
	SceneManager.change_scene("res://scenes/uis/SoundTrackMenu.tscn")
