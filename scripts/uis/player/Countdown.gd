extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	get_tree().paused = true
	Game.can_pause = false
	animation_player.play("countdown")
	await animation_player.animation_finished
	queue_free()

func end() -> void:
	get_tree().paused = false
	Game.can_pause = true
	MusicManager.play_music("level_plains")
