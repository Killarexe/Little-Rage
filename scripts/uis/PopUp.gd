extends ColorRect
class_name PopUp

@export var animation_player: AnimationPlayer
@export var button: Button
@export var icon: TextureRect
@export var text: Label

var on_pressed: Callable = func():pass

func _ready() -> void:
	button.pressed.connect(func(): on_pressed.call())
	animation_player.animation_finished.connect(func(_name: String): queue_free.call_deferred())
