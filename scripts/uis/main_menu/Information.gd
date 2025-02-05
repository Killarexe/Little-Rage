extends Label

func _ready() -> void:
	text = "Version " + Game.GAME_VERSION.as_str() + ", by Killar."

func _on_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/levels/CreditsScene.tscn")
