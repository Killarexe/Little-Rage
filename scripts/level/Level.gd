extends Node2D

func _ready():
	var player = load("res://scenes/prefabs/Player.tscn")
	Global.instanceNodeAtPos(player, self, Vector2(0, 0))
	if(name == "TitleLevel"):
		get_node("Player").set_max_y(2048)
		get_node("Player").global_position.x = 205
		get_node("Player").global_position.y = 850
		get_node("Player").enable_camera = false
		get_node("Player").get_node("Camera2D").queue_free()
		Global.unablePause()
