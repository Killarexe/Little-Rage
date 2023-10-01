extends BaseButton

@export var start_animation: bool = false
@export var mouse_over_animation: bool = false
@export var clicked_animation: bool = false

@export var start_animation_delay: float = 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	if start_animation:
		if start_animation_delay > 0.0:
			scale.x = 0 
			await get_tree().create_timer(start_animation_delay).timeout
			scale.x = 1
		animation_player.play("enter_scene")

func _on_pressed():
	if clicked_animation:
		animation_player.play("click")

func _on_mouse_entered():
	if mouse_over_animation:
		animation_player.play("select")

func _on_mouse_exited():
	if mouse_over_animation:
		animation_player.play_backwards("select")
