extends TextureButton

@export var item: PackedScene
@export var pos: Vector2

@onready var cursor = get_node("/root/LevelEditor/Cursor")
@onready var cursor_sprite = cursor.get_node("Sprite2D")
@onready var editor = get_node("/root/LevelEditor/Editor")

func _process(delta):
	global_position = pos * Vector2(size.x + 16, size.y + 16)

func _on_EditorItemButton_pressed():
	cursor.current_item = item
	cursor_sprite.texture = texture_normal
