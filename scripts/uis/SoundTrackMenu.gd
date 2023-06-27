extends CanvasLayer

@onready var music_list: ItemList = $MusicList

func _ready():
	MusicManager.stop()
	for music in MusicManager.musics:
		music_list.add_item(music.id)

func _on_music_list_item_selected(index: int):
	MusicManager.play_music(MusicManager.musics[index].id)

func _on_button_pressed():
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")
