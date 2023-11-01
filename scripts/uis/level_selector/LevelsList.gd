extends ItemList

signal on_level_selected(level: Level)

func _ready():
	for level in LevelManager.levels:
		add_item(level.id)

func _on_item_selected(index: int):
	on_level_selected.emit(LevelManager.levels[index])
