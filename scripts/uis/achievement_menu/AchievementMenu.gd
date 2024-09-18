extends CanvasLayer

@export var animation_player: AnimationPlayer

func _ready() -> void:
	MusicManager.play_music("achievement_menu")
	animation_player.play("entry")

func _on_back_button_pressed() -> void:
	animation_player.play_backwards("entry")
	await animation_player.animation_finished
	SceneManager.change_scene("res://scenes/uis/CollectionsMenu.tscn")
