extends Node2D
class_name PlayerCollider

@export var player: PlayerMovement

var checkpoint_particle: Resource = load("res://scenes/instances/level/player/particles/DefaultCheckpointParticle.tscn")
var previous_tile_type: int

func _ready():
	player.on_collide_tile.connect(on_collide)

func on_collide(type: int, pos: Vector2):
	var player_position: Vector2 = player.global_position
	match type:
		2:
			if previous_tile_type != type:
				player.spawn_point = player_position
				Global.instanceNodeAtPos(checkpoint_particle, player.get_parent(), player_position + Vector2(0, 16))
				player.on_setting_spawnpoint.emit(pos)
		3:
			if previous_tile_type != type:
				player.die()
		4:
			if previous_tile_type != type:
				player.finish_level()
		5:
			if previous_tile_type != type && previous_tile_type != 6:
				player.on_switch_color.emit(true)
		6:
			if previous_tile_type != type && previous_tile_type != 5:
				player.on_switch_color.emit(false)
	previous_tile_type = type
