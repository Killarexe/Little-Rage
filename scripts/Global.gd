extends Node

const GAME_NAME: String = "Little Rage"
var GAME_VERSION: GameVersion = GameVersion.from(0, 4, 0)

var loot_boxes: LootBoxesManager = LootBoxesManager.new()
var save: SaveManager = SaveManager.new()
var can_pause: bool = true

func _ready():
	save.load_save()

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
