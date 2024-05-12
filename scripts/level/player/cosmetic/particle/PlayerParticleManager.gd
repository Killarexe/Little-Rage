extends Node

const PARTICLES_DIR_PATH: String = "res://data/particles"

var current_death_particle: String = "default_death"
var current_jump_particle: String = "default_jump"
var current_step_particle: String = "default_step"

var unlocked_particles: Array = ["default"]
var particles: Array[PlayerParticle]

func _ready():
	var resources: Array[ResourceElement] = DataLoader.new().load_data_in_dir(PARTICLES_DIR_PATH, "particles")
	for resource in resources:
		if resource is PlayerParticle:
			particles.append(resource)

func get_current_particle_id(type: PlayerParticle.Type) -> String:
	match type:
		PlayerParticle.Type.JUMP:
			return get_particle(current_jump_particle).id
		PlayerParticle.Type.DEATH:
			return get_particle(current_death_particle).id
		PlayerParticle.Type.STEP:
			return get_particle(current_step_particle).id
	return "default_step"

func get_particle(particle_id: String) -> PlayerParticle:
	for particle in particles:
		if particle.id == particle_id:
			return particle
	return null

func unlock_particle(particle_id: String, special: bool = false):
	var particle: PlayerParticle = get_particle(particle_id)
	if particle != null && !is_particle_unlocked(particle_id):
		unlocked_particles.append(particle_id)
		SaveManager.save()
	if special:
		PopUpFrame.set_on_pressed(func():SceneManager.change_scene("res://scenes/uis/ShopMenu.tscn"))
		PopUpFrame.pop(TranslationServer.translate("ui.popup.unlocked_particle") % TranslationServer.translate(particle.name))

func is_particle_hidden(particle_id: String) -> bool:
	return get_particle(particle_id).is_hidden

func is_particle_unlocked(particle_id: String) -> bool:
	return unlocked_particles.has(particle_id)

func pick_random() -> String:
	var overall_chance: int = 0
	for particle in particles:
		if !particle.is_hidden:
			overall_chance += particle.chance
	var random_number = randi() % overall_chance
	var offset: int = 0
	for particle in particles:
		if !particle.is_hidden:
			if random_number < particle.chance + offset:
				if is_particle_unlocked(particle.id):
						offset += particle.chance
				else:
					return particle.id
			else:
				offset += particle.chance
	return "default"

func has_unlocked_all() -> bool:
	return unlocked_particles.size() >= particles.size()

func has_unlocked_unhiddens() -> bool:
	var unhidden_particles: int = particles\
		.filter(func(particle): return !particle.is_hidden)\
		.size()
	var unlocked_unhidden_particles: int = unlocked_particles\
		.filter(func(id): return !is_particle_hidden(id))\
		.size()
	return unhidden_particles <= unlocked_unhidden_particles

func spawn_particle(parent: Node, particle_position: Vector2, type: PlayerParticle.Type) -> Object:
	var id: String = get_current_particle_id(type)
	if !id.is_empty():
		var prefab_path: String = "res://scenes/bundles/particles/StepParticle.tscn"
		match type:
			PlayerParticle.Type.DEATH:
				prefab_path = "res://scenes/bundles/particles/PoofParticle.tscn"
			PlayerParticle.Type.JUMP:
				prefab_path = "res://scenes/bundles/particles/JumpParticle.tscn"
			PlayerParticle.Type.STEP:
				prefab_path = "res://scenes/bundles/particles/StepParticle.tscn"
		
		var particle: GPUParticles2D = load(prefab_path).instantiate()
		var particle_data: PlayerParticle = get_particle(id)
		if particle_data.texture.get_width() > 0:
			particle.texture = particle_data.texture
		particle.process_material = particle_data.material
		particle.global_position = particle_position
		parent.add_child(particle)
		return particle
	return null
