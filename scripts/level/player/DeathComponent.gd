extends Node
class_name DeathComponent

signal on_death(death_count: int)

@export_category("Component requirements")
@export var player: CharacterBody2D
@export var sound_effects: SoundEffectPlayer

var death_count: int = 0
var spawn_point: Vector2 = Vector2()
var y_limit: int = Level.DEFAULT_Y_LIMIT

func _ready() -> void:
	spawn_point = player.global_position
	var current_level: Level = LevelManager.get_current_level()
	if current_level != null:
		y_limit = LevelManager.get_current_level().y_limit

func _physics_process(_delta: float) -> void:
	if player.global_position.y >= y_limit:
		die()

func die() -> void:
	sound_effects.play_sfx("die")
	if !Input.get_connected_joypads().is_empty():
		Input.start_joy_vibration(0, 1.0, 1.0, 0.25)
	death_count += 1
	on_death.emit(death_count)
	player.global_position = spawn_point
