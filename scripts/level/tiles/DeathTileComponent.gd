extends Node
class_name DeathTileComponent

@export var interactive_tile: InteractiveTile

func _ready() -> void:
	interactive_tile.on_body_entered.connect(on_interact)

func on_interact(body: Node2D) -> void:
	var death_component: DeathComponent = body.get_node_or_null("DeathComponent")
	if death_component != null:
		death_component.die()
