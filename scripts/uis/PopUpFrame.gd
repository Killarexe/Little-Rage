extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Frame/AnimationPlayer
@onready var sound_effect: AudioStreamPlayer = $Frame/SoundEffect
@onready var icon: TextureRect = $Frame/Icon
@onready var text: Label = $Frame/Text

var on_pressed: Callable = func():pass

func set_on_pressed(value: Callable) -> void:
	on_pressed = value

func pop_translated(message: String, icon_texture: Texture2D = null) -> void:
	pop(TranslationServer.translate(message), icon_texture)

func pop(message: String, icon_texture: Texture2D = null) -> void:
	text.text = message
	icon.texture = icon_texture
	animation_player.play("pop")

func _on_animation_player_animation_finished(_unused: String) -> void:
	text.text = ""
	icon.texture = null
	on_pressed = func():pass

func _on_button_pressed() -> void:
	on_pressed.call()
