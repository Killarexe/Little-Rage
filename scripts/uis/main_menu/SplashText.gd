extends Label

@export var texts: Array[String] = []
var index: int = 0

func _ready():
	$AnimationPlayer.play("zoom")
	if texts.size() <= 0:
		text = "Hello, world!"
	else:
		index = randi_range(0, texts.size() - 1)
		text = texts[index]

func _on_button_pressed():
	match index:
		51 | 17:
			PlayerSkinManager.unhide_skin("steve")
		2:
			PlayerSkinManager.unhide_skin("killarexe")
		9:
			PlayerSkinManager.unhide_skin("niark")
