extends CanvasLayer

@onready var texture_rect = $TextureRect

func _ready():
	texture_rect.texture = load("res://textures/uis/vignette.png")
