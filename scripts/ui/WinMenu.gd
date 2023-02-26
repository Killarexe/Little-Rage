extends Control

func _ready():
	pass

func start(player):
	visible = true
	yield(get_tree().create_timer(0.5), "timeout")
	for i in player.deathCount:
		$Results.text = "Deaths: " + str(i) + "\nCoins:\n\nTotal Score:"
		yield(get_tree().create_timer(0.1), "timeout")
	yield(get_tree().create_timer(0.5), "timeout")
	for i in 5:
		$Results.text = "Deaths: " + str(player.deathCount) + "\nCoins:" + str(i) + "\n\nTotal Score:"
		yield(get_tree().create_timer(0.1), "timeout")
	yield(get_tree().create_timer(0.5), "timeout")
	$Results.text = "Deaths: " + str(player.deathCount) + "\nCoins:5\n\nTotal Score:0"

func _on_ContinueButton_pressed():
	get_tree().paused = false
	Global.unlockNextLevel()
	SceneTransition.change_scene("res://scenes/ui/MainMenu.tscn")
