extends Node2D
class_name PlayerCollider

@export var player: PlayerMovement

var checkpoint_particle: Resource = null
var previous_tile_type: int

func _ready():
	checkpoint_particle = load("res://scenes/instances/level/player/particles/DefaultCheckpointParticle.tscn")

func _process(_delta: float):
	if !player.interactable:
		return
	for i in player.get_slide_collision_count():
		var collision: KinematicCollision2D = player.get_slide_collision(i)
		var collider: Node = collision.get_collider() as Node
		
		if collider is TileMap:
			var pos: Vector2 = collider.local_to_map(collision.get_position() - collision.get_normal() - Vector2(1, 0))
			var cell: TileData = collider.get_cell_tile_data(0, pos)
			if cell != null:
				var type = cell.get_custom_data("type")
				if type != null && type is int:
					on_collide(type, pos)
			
		if collider.is_in_group("player"):
			#TODO: knockback between players
			pass

func on_collide(type: int, pos: Vector2):
	var player_position: Vector2 = player.global_position
	match type:
		2:
			if previous_tile_type != type:
				player.spawn_point = player_position
				Game.instanceNodeAtPos(checkpoint_particle, player.get_parent(), pos * Vector2(16, 16) - Vector2(-8, 8))
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
