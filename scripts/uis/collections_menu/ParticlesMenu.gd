extends Control

@onready var death_list: ItemList = $Particles/DeathTab/List
@onready var jump_list: ItemList = $Particles/JumpTab/List
@onready var run_list: ItemList = $Particles/RunTab/List

@onready var main_menu: MainCollectionMenu = $"../MainMenu"
@onready var camera_animation_player: AnimationPlayer = $"../../DefaultLevel/Player/PlayerViewer/AnimationPlayer"
@onready var player: PlayerMovement = $"../../DefaultLevel/Player"

var death_particle_ids: Array[String] = []
var jump_particle_ids: Array[String] = []
var run_particle_ids: Array[String] = []

func _ready():
	death_list.item_selected.connect(_on_death_list_selected)
	jump_list.item_selected.connect(_on_jump_list_selected)
	run_list.item_selected.connect(_on_run_particle_list_selected)
	for particle in PlayerParticleManager.particles:
		if PlayerParticleManager.is_particle_unlocked(particle.id):
			match particle.type:
				PlayerParticle.Type.DEATH:
					death_list.add_item(particle.id, particle.texture)
					if particle.id == PlayerParticleManager.current_death_particle:
						death_list.select(death_particle_ids.size())
					death_particle_ids.append(particle.id)
				PlayerParticle.Type.JUMP:
					jump_list.add_item(particle.id, particle.texture)
					if particle.id == PlayerParticleManager.current_jump_particle:
						jump_list.select(jump_particle_ids.size())
					jump_particle_ids.append(particle.id)
				PlayerParticle.Type.STEP:
					run_list.add_item(particle.id, particle.texture)
					if particle.id == PlayerParticleManager.current_step_particle:
						run_list.select(run_particle_ids.size())
					run_particle_ids.append(particle.id)

func _on_death_list_selected(index: int):
	PlayerParticleManager.current_death_particle = death_particle_ids[index]

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
