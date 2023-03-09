extends Control

func _ready() -> void:
	$Uis/Control/MusicBar.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	$Uis/Control/SFXBar.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFXS"))
	Global.saveGame()

func _on_MusicBar_value_changed(value) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	Global.saveGame()

func _on_SFXBar_value_changed(value) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFXS"), value)
	Global.saveGame()

func _on_ResetButton_pressed() -> void:
	Global.resetGame()

func _on_QuitButton_pressed() -> void:
	SceneTransition.change_scene_to_file("res://scenes/ui/MainMenu.tscn")
