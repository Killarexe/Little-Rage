extends ResourceElement
class_name Music

enum Type{
	LEVEL,
	MENU
}

@export var stream: AudioStream = AudioStream.new()
@export var type: Type = Type.MENU
