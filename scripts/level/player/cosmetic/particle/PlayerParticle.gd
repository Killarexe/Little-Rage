extends CosmeticElement
class_name PlayerParticle

const GENERATED_TEXTURE_SIZE: int = 8

enum Type{
	STEP,
	JUMP,
	DEATH
}

@export var type: Type = Type.STEP
@export var material: ParticleProcessMaterial = ParticleProcessMaterial.new()

func get_texture_or_default() -> Texture2D:
	if texture != null:
		if texture.get_width() != 0:
			return texture
	var color_image: Image = Image.create(GENERATED_TEXTURE_SIZE, GENERATED_TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	color_image.fill(material.color)
	return ImageTexture.create_from_image(color_image)
