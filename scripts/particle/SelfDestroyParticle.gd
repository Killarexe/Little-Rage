extends GPUParticles2D
class_name SelfDestroyParticle

var emmited: bool = false

func _process(_delta):
	if emitting:
		emmited = true
	elif emmited:
		queue_free()
