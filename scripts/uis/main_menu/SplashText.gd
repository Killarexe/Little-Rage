extends Label

@export var texts: Array[String] = []
var index: int = 0

func _ready():
	$AnimationPlayer.play("zoom")
	if texts.size() <= 0:
		text = "Hello, world!"
	else:
		randomize()
		index = randi_range(0, texts.size() - 1)
		text = texts[index]

func _on_button_pressed():
	match index:
		51:
			PlayerSkinManager.unlock_skin("steve", true)
		17:
			PlayerSkinManager.unlock_skin("steve", true)
		2:
			PlayerSkinManager.unlock_skin("killarexe", true)
		9:
			PlayerSkinManager.unlock_skin("niark", true)
		65:
			PlayerSkinManager.unlock_skin("niark", true)
		61:
			PlayerSkinManager.unlock_skin("rgb", true)
		48:
			PlayerSkinManager.unlock_skin("rgb", true)
		49:
			PlayerSkinManager.unlock_skin("rainer", true)
