extends ResourceElement
class_name CosmeticElement

@export var name: String
@export var chance: int = 1
@export var is_hidden: bool = false
@export var texture: CompressedTexture2D = CompressedTexture2D.new()

func get_texture_or_default():
	return texture
