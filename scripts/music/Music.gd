extends ResourceElement
class_name Music

enum Type{
	LEVEL,
	MENU
}

@export var streams: Array[AudioStream] = []
@export var type: Type = Type.MENU

func get_stream_from_index(index: int) -> AudioStream:
	if index < streams.size():
		return streams[index]
	return streams[0]

func get_stream() -> AudioStream:
	return get_stream_from_index(randi_range(0, streams.size() - 1))
