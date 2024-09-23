extends Node
class_name DeathTileComponent

@export var interactive_tile: InteractiveTile

func _ready() -> void:
	interactive_tile.on_body_entered.connect(on_interact)

func on_interact(body: Node2D) -> void:
	if body is PlayerComponent:
		body.death_component.die()
