extends TabContainer

@onready var cursor = get_parent().get_parent().get_node("Cursor")
var ui_position: Vector2 = Vector2(global_position.x, global_position.x)
var tab_size: Vector2 = Vector2(size.x, size.y)
var cursor_position: Vector2 = Vector2()

func _process(delta):
	if Input.is_action_just_pressed("play_toggle_editor"):
		if Global.editor_playing:
			get_parent().get_node("/root/LevelEditor/Level/Player").queue_free()
		else:
			Global.instanceNodeAtPos(load("res://scenes/prefabs/Player.tscn"), get_parent().get_node("/root/LevelEditor/Level"), Vector2(0, 0))
		visible = Global.editor_playing
		cursor.show_sprite(Global.editor_playing)
		Global.editor_playing = !Global.editor_playing
	if !Global.editor_playing:
		cursor_position = Vector2(cursor.position.x + 960, cursor.position.y + 540)
		cursor.can_place = !(((cursor_position.x >= ui_position.x && cursor_position.x < ui_position.x + size.x) ||
			(ui_position.x >= cursor_position.x && ui_position.x < cursor_position.x)) && ((cursor_position.y >= ui_position.y && cursor_position.y < ui_position.y + size.y) ||
			(ui_position.y >= cursor_position.y && ui_position.y < cursor_position.y)))
		cursor.show_sprite(cursor.can_place)
