extends Node2D

const world_size = Vector2(128, 32)

func _ready():
	var player = load("res://scenes/prefabs/Player.tscn")
	var instancePlayer = Global.instanceNodeAtPos(player, self, Vector2(16, world_size.y * -2))
	generateMap()

func generateMap():
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	for x in world_size.x:
		for y in world_size.y:
			$Ground.set_cellv(Vector2(x, y), 20)
	$Ground.update_bitmask_region (Vector2(0, 0), Vector2(world_size.x, world_size.y))
