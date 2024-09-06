extends StaticBody2D
class_name InteractiveTile

@export_category("Interaction Tile Dependencies")
@export var interatcion_area: Area2D

func _ready() -> void:
	interatcion_area.body_entered.connect(on_body_entered)
	interatcion_area.body_exited.connect(on_body_exited)

func on_body_entered(body: Node2D) -> void:
	pass

func on_body_exited(body: Node2D) -> void:
	pass
