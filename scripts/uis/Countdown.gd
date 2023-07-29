extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label

func _ready():
	Global.can_pause = false
	get_tree().paused = true
	label.text = "3"
	animation_player.play("fade")
	await animation_player.animation_finished
	label.text = "2"
	animation_player.play("fade")
	await animation_player.animation_finished
	label.text = "1"
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().paused = false
	Global.can_pause = true
	queue_free()
