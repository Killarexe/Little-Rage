extends GPUParticles2D
class_name SelfDestroyParticle

func _ready() -> void:
	one_shot = true
	emitting = true
	await finished
	if !Engine.is_editor_hint():
		queue_free()
