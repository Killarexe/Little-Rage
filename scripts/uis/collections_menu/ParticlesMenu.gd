extends Control

const GENERATED_TEXTURE_SIZE: int = 8

@export var jump_list: ItemList
@export var run_list: ItemList

@export var main_menu: MainCollectionMenu
@export var camera_animation_player: AnimationPlayer
@export var player: PlayerDummyComponent

var jump_particle_ids: Array[String] = []
var run_particle_ids: Array[String] = []

func _ready():
	jump_list.item_selected.connect(_on_jump_list_selected)
	run_list.item_selected.connect(_on_run_particle_list_selected)
	for particle in PlayerParticleManager.particles:
		if PlayerParticleManager.is_particle_unlocked(particle.id):
			match particle.type:
				PlayerParticle.Type.JUMP:
					add_to_list(jump_list, particle)
					if particle.id == PlayerParticleManager.current_jump_particle:
						jump_list.select(jump_particle_ids.size())
					jump_particle_ids.append(particle.id)
				PlayerParticle.Type.STEP:
					add_to_list(run_list, particle)
					if particle.id == PlayerParticleManager.current_step_particle:
						run_list.select(run_particle_ids.size())
					run_particle_ids.append(particle.id)

func add_to_list(list: ItemList, particle: PlayerParticle):
	var texture: Texture2D = particle.texture
	if texture == null || texture.get_width() == 0 || texture.get_height() == 0:
		var color_image: Image = Image.create(GENERATED_TEXTURE_SIZE, GENERATED_TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
		color_image.fill(particle.material.color)
		texture = ImageTexture.create_from_image(color_image)
	list.add_item(particle.name, texture)

func _on_jump_list_selected(index: int):
	player.jump_timer = player.JUMP_TIME
	PlayerParticleManager.current_jump_particle = jump_particle_ids[index]

func _on_run_particle_list_selected(index: int):
	PlayerParticleManager.current_step_particle = run_particle_ids[index]

func _on_back_button_pressed():
	visible = false
	camera_animation_player.play_backwards("zoom_particles")
	main_menu.visible = true
	await camera_animation_player.animation_finished
	main_menu.animation_player.play("enter")
