extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Frame/AnimationPlayer
@onready var sound_effect: AudioStreamPlayer = $Frame/SoundEffect
@onready var icon: TextureRect = $Frame/Icon
@onready var text: Label = $Frame/Text

func pop_translated(message: String, icon_texture: Texture2D = null):
	pop(TranslationServer.translate(message), icon_texture)

func pop(message: String, icon_texture: Texture2D = null):
	text.text = message
	icon.texture = icon_texture
	animation_player.play("pop")
	#TODO: Play a sound effect when pops

func _on_animation_player_animation_finished(_unused: String):
	text.text = ""
	icon.texture = null
