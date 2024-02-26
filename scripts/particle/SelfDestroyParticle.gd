extends GPUParticles2D
class_name SelfDestroyParticle

func _ready():
	one_shot = true
	emitting = true
	await finished
	queue_free()
