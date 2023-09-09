extends ItemList

func _ready():
	for index in item_count:
		set_item_text(index, TranslationServer.translate(get_item_text(index)))
