extends Node
class_name FinishTileComponent

@export var interaction_tile: InteractiveTile

func _ready() -> void:
	interaction_tile.on_body_entered.connect(on_interact)

func on_interact(body: Node2D) -> void:
	if body is PlayerComponent:
		get_tree().call_group("Level", "finish_level", body)
