extends Node

@onready var best_time_text = $BestTime
@onready var left_button = $Levels/LeftButton
@onready var right_button = $Levels/RightButton
@onready var level_button = $Levels/LevelButton

func _ready():
	MusicPlayer.play_music(0)
	update_button()

func _on_ExitButton_pressed():
	SceneTransition.change_scene_to_file("res://scenes/ui/MainMenu.tscn")

func _on_LevelButton_pressed():
	SceneTransition.change_scene_to_file("res://scenes/levels/Level" + str(LevelManager.currentLevel + 1) +".tscn")

func _on_LeftButton_pressed():
	if LevelManager.currentLevel <= 0:
		left_button.disabled = true
	else:
		right_button.disabled = false
		LevelManager.currentLevel -= 1
		update_button()

func _on_RightButton_pressed():
	if LevelManager.currentLevel + 1 >= LevelManager.LEVELS.size():
		right_button.disabled = true
	else:
		left_button.disabled = false
		LevelManager.currentLevel += 1
		update_button()

func update_button():
	level_button.text = "Level " + str(LevelManager.currentLevel + 1)
	best_time_text.text = "Best Time: " + LevelManager.get_level_best_time_str(LevelManager.currentLevel)
	if LevelManager.currentLevel <= LevelManager.LEVELS.size():
		level_button.disabled = !LevelManager.is_level_unlocked(LevelManager.currentLevel)
