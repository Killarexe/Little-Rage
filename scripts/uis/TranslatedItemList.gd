extends ItemList

func _ready() -> void:
	for index in item_count:
		set_item_text(index, TranslationServer.translate(get_item_text(index)))
	select(2)
