extends ResourceElement
class_name Achievement

enum Type {
  NORMAL,
  RARE,
  EPIC
}

@export var icon: CompressedTexture2D = null
@export var type: Type = Type.NORMAL
@export var hidden: bool = false
