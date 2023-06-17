extends Node

const GAME_NAME: String = "Little Rage"
var GAME_VERSION: GameVersion = GameVersion.from(0, 4, 0)

var save: SaveManager = SaveManager.new()
var can_pause: bool = true
var coins: int = 0

func _ready():
	save.load_save()

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
