extends StaticBody2D
class_name InteractiveTile

signal on_body_entered(body: Node2D)
signal on_body_exited(body: Node2D)

@export_category("Interaction Tile Dependencies")
@export var interatcion_area: Area2D

func _ready() -> void:
	interatcion_area.body_entered.connect(func(body: Node2D): on_body_entered.emit(body))
	interatcion_area.body_exited.connect(func(body: Node2D): on_body_exited.emit(body))
