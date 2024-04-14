extends Label

func _ready():
	text = "Version " + Game.GAME_VERSION.as_str() + ". By Killar.exe"

func _on_button_pressed():
	SceneManager.change_scene("res://scenes/levels/CreditsScene.tscn")
