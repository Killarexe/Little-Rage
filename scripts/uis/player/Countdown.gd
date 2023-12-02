extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	get_tree().paused = true
	Global.can_pause = false
	animation_player.play("countdown")
	await animation_player.animation_finished
	queue_free()

func end():
	get_tree().paused = false
	Global.can_pause = true
	MusicManager.play_music("level_plains")
