extends Control

var selectedLevel: int = 1

func _ready():
	Global.play_music(0)
	update_button()

func _on_ExitButton_pressed():
	SceneTransition.change_scene_to_file("res://scenes/ui/MainMenu.tscn")

func _on_LevelButton_pressed():
	Global.currentLevel = selectedLevel
	SceneTransition.change_scene_to_file("res://scenes/levels/Level" + str(selectedLevel) +".tscn")

func _on_LeftButton_pressed():
	if selectedLevel <= 1:
		$Levels/LeftButton.disabled = true
	else:
		$Levels/RightButton.disabled = false
		selectedLevel -= 1
		update_button()

func _on_RightButton_pressed():
	if selectedLevel >= Global.levels.size():
		$Levels/RightButton.disabled = true
	else:
		$Levels/LeftButton.disabled = false
		selectedLevel += 1
		update_button()

func update_button():
	$Levels/LevelButton.text = "Level " + str(selectedLevel)
	if selectedLevel > Global.unlockedLevels.size():
		$Levels/LevelButton.disabled = true
	else:
		$Levels/LevelButton.disabled = false
