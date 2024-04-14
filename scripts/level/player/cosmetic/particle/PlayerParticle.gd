extends CosmeticElement
class_name PlayerParticle

enum Type{
	STEP,
	JUMP,
	DEATH
}

@export var type: Type = Type.STEP
@export var material: ParticleProcessMaterial = ParticleProcessMaterial.new()
