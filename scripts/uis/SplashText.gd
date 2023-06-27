extends Label

@export var texts: Array[String] = []

func _ready():
	$AnimationPlayer.play("zoom")
	if texts.size() <= 0:
		text = "Hello, world!"
	else:
		text = texts[randi_range(0, texts.size() - 1)]
