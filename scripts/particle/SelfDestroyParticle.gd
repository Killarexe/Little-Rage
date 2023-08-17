extends GPUParticles2D

var emmited: bool = false

func _process(_delta):
	if emitting:
		emmited = true
	elif emmited:
		queue_free()
