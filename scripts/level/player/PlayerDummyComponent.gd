extends CharacterBody2D
class_name PlayerDummyComponent

@export_category("Cosmetic components")
@export var player_skin: PlayerSkinSprite
@export var player_hat: PlayerHatSprite
@export_category("Cosmetic settings")
@export var override_hat_id: String
@export var override_skin_id: String

@export_category("Component requirement")
@export var animation: AnimationPlayer
@export var sound_effect_player: SoundEffectPlayer
@export var movement: PlayerDummyMovement

func _ready() -> void:
	player_skin.update_skin(override_skin_id)
	player_hat.update_hat(override_hat_id)

func flip_sprite() -> void:
	player_skin.flip_h = !player_skin.flip_h

func jump_player() -> void:
	movement.jump_timer = movement.JUMP_TIME
