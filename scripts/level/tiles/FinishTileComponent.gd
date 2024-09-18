extends Node
class_name FinishTileComponent

@export var interaction_tile: InteractiveTile

func _ready() -> void:
	interaction_tile.on_body_entered.connect(on_interact)

func on_interact(body: Node2D) -> void:
	if body is PlayerComponent:
		var death_component: DeathComponent = body.get_node_or_null("DeathComponent") as DeathComponent
		var timer: PlayerTimer = body.get_node_or_null("Timer") as PlayerTimer
		if death_component != null && timer != null:
			get_tree().call_group("Level", "finish_level", body, death_component, timer)
