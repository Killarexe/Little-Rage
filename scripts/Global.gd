extends Node

const GAME_NAME: String = "Little Rage"
var GAME_VERSION: GameVersion = GameVersion.from(0, 4, 0)

var discord_rpc: DiscordRPCManager = DiscordRPCManager.new()
var save: SaveManager = SaveManager.new()
var coins: int = 0

func _ready():
	save.load_save()
	discord_rpc.start()

func instanceNodeAtPos(node: Object, parent: Object, pos: Vector2) -> Object:
	var nodeInstance = instanceNode(node, parent)
	nodeInstance.global_position = pos
	return nodeInstance

func instanceNode(node: Object, parent: Object) -> Object:
	var nodeInstance = node.instantiate()
	parent.add_child(nodeInstance)
	return nodeInstance 

func save_game():
	save.save()
