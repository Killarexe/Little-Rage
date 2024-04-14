
static func get_icon(default_icon: Texture2D, is_unlocked: bool) -> Texture2D:
	if is_unlocked:
		return default_icon
	var image: Image = default_icon.get_image()
	return null
