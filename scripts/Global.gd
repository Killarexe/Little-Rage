extends Node

const GAME_NAME: String = "Little Rage"
const WINDOW_SIZES: Array[Vector2] = [
	Vector2(670, 360),
	Vector2(768, 432),
	Vector2(896, 504),
	Vector2(1024, 576),
	Vector2(1152, 648),
	Vector2(1280, 720),
]

var GAME_VERSION: GameVersion = GameVersion.from(0, 5, 0)
var loot_boxes: LootBoxesManager = LootBoxesManager.new()
var save: SaveManager = SaveManager.new()
var can_pause: bool = true
var is_mobile: bool = false
var starting: bool = true
var window_size: int = 5
var settings_time: int = 0

func _ready():
	save.load_save()
	is_mobile = OS.get_name() == "Android" || OS.get_name() == "iOS"
	update_window(window_size)

func update_window(size: int):
	if size < WINDOW_SIZES.size():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(WINDOW_SIZES[size])
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _unhandled_key_input(event: InputEvent):
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if event is InputEventKey:
		pass #TODO: "Cheat code" impl

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST || what == NOTIFICATION_WM_GO_BACK_REQUEST:
		save_game()
		get_tree().quit()

func instanceNodeAtPos(node: Object, parent: Object, pos: Vector2) -> Object:
	var nodeInstance = instanceNode(node, parent)
	nodeInstance.global_position = pos
	return nodeInstance

func instanceNode(node: Object, parent: Object) -> Object:
	var nodeInstance = node.instantiate()
	parent.add_child(nodeInstance)
	return nodeInstance 

func reset_save():
	save.create_save()
	save.load_save()

func save_game():
	save.save()
