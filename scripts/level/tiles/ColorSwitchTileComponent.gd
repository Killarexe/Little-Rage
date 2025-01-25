extends Node
class_name ColorSwitchTileComponent

@export var interactive_tile: InteractiveTile
@export var off_texture: Sprite2D
@export var sound_effect_player: SoundEffectPlayer

func _ready() -> void:
	interactive_tile.on_body_entered.connect(on_interact)

func on_interact(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().call_group("ColorTiles", "switch_texture")
		sound_effect_player.play_sfx("click")
