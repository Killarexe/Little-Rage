extends CanvasLayer


@onready var music_list: ItemList = $MusicList

var music_ids: Array[String] = []

func _ready():
	MusicManager.stop()
	var music_dir: DirAccess = DirAccess.open(MusicManager.MUSIC_DIR_PATH)
	for file_name in music_dir.get_files():
		if !file_name.ends_with(".import") || Game.is_mobile:
			var music_id: String = file_name.replace(".ogg", "").replace(".import", "")
			music_ids.append(music_id)
			music_list.add_item(music_id.replace("_", " "))

func _on_music_list_item_selected(index: int):
	MusicManager.play_music(music_ids[index])

func _on_button_pressed():
	SceneManager.change_scene("res://scenes/uis/MainMenu.tscn")
