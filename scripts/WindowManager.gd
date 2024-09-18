extends Node

const WINDOW_SIZES: Array[Vector2] = [
	Vector2(670, 360),
	Vector2(768, 432),
	Vector2(896, 504),
	Vector2(1024, 576),
	Vector2(1152, 648),
	Vector2(1280, 720),
]

var window_size: int = 5

func _ready() -> void:
	update_window(window_size)

func update_window(size: int) -> void:
	if size < WINDOW_SIZES.size():
		var window_size: Vector2 = WINDOW_SIZES[size]
		var current_screen: int = DisplayServer.window_get_current_screen()
		var screen_size: Vector2 = DisplayServer.screen_get_size(current_screen)
		var screen_position: Vector2 = DisplayServer.screen_get_position(current_screen)
		var window_position: Vector2 = screen_size / 2 + screen_position - window_size / 2
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(window_size)
		DisplayServer.window_set_position(window_position)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST || what == NOTIFICATION_WM_GO_BACK_REQUEST:
		SaveManager.save()
		get_tree().quit()
