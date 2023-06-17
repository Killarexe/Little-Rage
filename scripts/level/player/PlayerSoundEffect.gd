extends ResourceElement
class_name PlayerSoundEffect

enum Type{
	JUMP,
	KNOCKBACK,
	DIE,
}

@export var stream: AudioStream = AudioStream.new()
@export var type: Type = Type.DIE
@export var pitch_max_offset: float = 0.0
