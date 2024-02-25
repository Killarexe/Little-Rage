extends CollisionShape2D
class_name PlayerCollider

@export var player: PlayerComponent
@export var death_component: DeathComponent
@export var player_controller: PlayerControllerComponent

var checkpoint_particle: Resource = null
var previous_tile_type: int = 0

func _ready():
	checkpoint_particle = preload("res://scenes/instances/level/player/particles/DefaultCheckpointParticle.tscn")

func _process(_delta: float):
	if player_controller:
		if player_controller.ground_timer < 0:
			previous_tile_type = 0
	
	for i in player.get_slide_collision_count():
		var collision: KinematicCollision2D = player.get_slide_collision(i)
		var collider: Node = collision.get_collider() as Node
		
		if collider is TileMap:
			var pos: Vector2 = collider.local_to_map(collision.get_position() - collision.get_normal() - Vector2(2, 0))
			var cell: TileData = collider.get_cell_tile_data(0, pos)
			if cell != null:
				var type = cell.get_custom_data("type")
				if type == null:
					type = 0
				on_collide(type, pos)
			var front_pos: Vector2 = collider.local_to_map(collision.get_position() - collision.get_normal() - Vector2(1, 0))
			var front_cell: TileData = collider.get_cell_tile_data(0, front_pos)
			if front_cell != null:
				var type = front_cell.get_custom_data("type")
				if type == 4:
					player.finish_level()

func on_collide(type: int, pos: Vector2):
	if previous_tile_type != type:
		match type:
			2:
				var spawnpoint_position: Vector2 = pos * Vector2(16, 16) - Vector2(-8, 8)
				player.spawn_point = spawnpoint_position
				Game.instanceNodeAtPos(checkpoint_particle, player.get_parent(), spawnpoint_position)
				player.on_setting_spawnpoint.emit(pos)
			3:
				death_component.die()
			4:
				player.finish_level()
			5:
				if previous_tile_type != 6:
					player.on_switch_color.emit(true)
			6:
				if previous_tile_type != 5:
					player.on_switch_color.emit(false)
	previous_tile_type = type
