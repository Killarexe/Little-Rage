extends TextureButton

export(PackedScene) var item
export(Vector2) var position

onready var cursor = get_node("/root/LevelEditor/Cursor")
onready var cursor_sprite = cursor.get_node("Sprite")
onready var editor = get_node("/root/LevelEditor/Editor")

func _process(delta):
	rect_global_position = position * Vector2(rect_size.x + 16, rect_size.y + 16)

func _on_EditorItemButton_pressed():
	cursor.current_item = item
	cursor_sprite.texture = texture_normal
