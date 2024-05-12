extends Node

enum Event {
	NONE,
	ANNIVERSARY,
	CHRISTMAS,
	HALLOWEEN
}

const GAME_NAME: String = "Little Rage"
var GAME_VERSION: GameVersion = GameVersion.from(0, 6, 0)

var current_event: Event = Event.NONE
var is_mobile: bool = false
var can_pause: bool = true
var starting: bool = true

func _ready():
	is_mobile = OS.get_name() == "Android" || OS.get_name() == "iOS"
	var date = Time.get_datetime_dict_from_system()
	var day: int = date["day"]
	var month: int = date["month"]
	if (day >= 23 && day <= 26) && month == 12:
		RenderingServer.set_default_clear_color(Color.hex(0x80cff7FF))
		PlayerSkinManager.unlock_skin("santa")
		PlayerHatManager.unlock_hat("santa_hat")
		AchievementManager.unlock_achievement("christmas_event")
		current_event = Event.CHRISTMAS
	elif (day == 30 || day == 31) && month == 10:
		RenderingServer.set_default_clear_color(Color.hex(0x1b1c28FF))
		AchievementManager.unlock_achievement("halloween_event")
		current_event = Event.HALLOWEEN
	elif day == 24 && month == 3:
		PlayerSkinManager.unlock_skin("old_player", true)
		print_rich("[wave amp=50.0 freq=5.0 connected=1][rainbow freq=1.0 sat=0.8 val=0.8]Happy Birthday Little Rage![/rainbow][/wave]")
		current_event = Event.ANNIVERSARY

func has_unlocked_unhiddens():
	return PlayerHatManager.has_unlocked_unhiddens() && PlayerSkinManager.has_unlocked_unhiddens() && PlayerParticleManager.has_unlocked_unhiddens()

func instanceNodeAtPos(node: Object, parent: Object, pos: Vector2) -> Object:
	var nodeInstance = instanceNode(node, parent)
	nodeInstance.global_position = pos
	return nodeInstance

func instanceNode(node: Object, parent: Object) -> Object:
	var nodeInstance = node.instantiate()
	parent.add_child(nodeInstance)
	return nodeInstance

func _exit_tree():
	GAME_VERSION.free() #NOTE: is to fix a bug a think...
