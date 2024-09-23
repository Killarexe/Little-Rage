extends Node
class_name SkinDistortionComponent

@export var skin: PlayerSkinSprite
@export var player: CharacterBody2D
@export var controller: PlayerDummyMovement

const DOWN_DISTORTION: float = 0.25 #Set to 0.25 but at 0.75 it's kinda fun to watch :joy:

func _process(delta: float) -> void:
	skin.global_skew = lerpf(skin.global_skew, player.velocity.x / 1000, 0.2)
	if controller:
		if Input.is_action_pressed("down") && controller.ground_timer > controller.GROUND_TIME - 0.1:
			player.scale.y = lerpf(player.scale.y, 1 - DOWN_DISTORTION, 10 * delta)
			player.scale.x = lerpf(player.scale.x, 1 + DOWN_DISTORTION, 10 * delta)
			return
	player.scale.y = lerpf(player.scale.y, 1, 10 * delta)
	player.scale.x = lerpf(player.scale.x, 1, 10 * delta)
	skin.scale.y = lerpf(skin.scale.y, abs(player.velocity.y) / controller.MAX_FALL_SPEED / 4 + 1, 0.2)
