extends Node

func _ready():
	MusicPlayer.play_music(0)
	update_button()

func _on_ExitButton_pressed():
	SceneTransition.change_scene_to_file("res://scenes/ui/MainMenu.tscn")

func _on_LevelButton_pressed():
	SceneTransition.change_scene_to_file("res://scenes/levels/Level" + str(LevelManager.currentLevel + 1) +".tscn")

func _on_LeftButton_pressed():
	if LevelManager.currentLevel <= 0:
		$Levels/LeftButton.disabled = true
	else:
		$Levels/RightButton.disabled = false
		LevelManager.currentLevel -= 1
		update_button()

func _on_RightButton_pressed():
	if LevelManager.currentLevel + 1 >= LevelManager.LEVELS.size():
		$Levels/RightButton.disabled = true
	else:
		$Levels/LeftButton.disabled = false
		LevelManager.currentLevel += 1
		update_button()

func update_button():
	$Levels/LevelButton.text = "Level " + str(LevelManager.currentLevel + 1)
	$BestTime.text = "Best Time: " + LevelManager.get_level_best_time_str(LevelManager.currentLevel)
	if LevelManager.currentLevel <= LevelManager.LEVELS.size():
		$Levels/LevelButton.disabled = !LevelManager.is_level_unlocked(LevelManager.currentLevel)
