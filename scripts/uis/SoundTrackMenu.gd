extends CanvasLayer

@onready var music_list: ItemList = $MusicList

func _ready():
	MusicManager.stop()
	var music_dir: DirAccess = DirAccess.open("res://assets/musics/")
	for file_name in music_dir.get_files():
		music_list.add_item(file_name.replace(".ogg", ""))

func _on_music_list_item_selected(index: int):
	MusicManager.play_music(music_list.get_item_text(index))

func _on_button_pressed():
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")
