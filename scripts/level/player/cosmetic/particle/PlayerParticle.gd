extends CosmeticElement
class_name PlayerParticle

enum Type{
	RUN,
	JUMP,
	DEATH
}

@export var type: Type = Type.RUN
@export var prefab: PackedScene = PackedScene.new()
