extends Control
class_name ParticlesMenu

const GENERATED_TEXTURE_SIZE: int = 8

@export var jump_list: ItemList
@export var run_list: ItemList

@export var main_menu: MainCollectionMenu
@export var camera_animation_player: AnimationPlayer
@export var player: PlayerDummyComponent

var jump_particle_ids: Array[String] = []
var run_particle_ids: Array[String] = []

func _ready() -> void:
  jump_list.item_selected.connect(_on_jump_list_selected)
  run_list.item_selected.connect(_on_run_particle_list_selected)
  load_particles()

func load_particles() -> void:
  jump_list.clear()
  run_list.clear()
  jump_particle_ids.clear()
  run_particle_ids.clear()
  for particle in PlayerParticleManager.particles:
    if PlayerParticleManager.is_particle_unlocked(particle.id):
      match particle.type:
        PlayerParticle.Type.JUMP:
          jump_list.add_item(TranslationServer.translate(particle.name), particle.get_texture_or_default())
          if particle.id == PlayerParticleManager.current_jump_particle:
            jump_list.select(jump_particle_ids.size())
          jump_particle_ids.append(particle.id)
        PlayerParticle.Type.STEP:
          run_list.add_item(TranslationServer.translate(particle.name), particle.get_texture_or_default())
          if particle.id == PlayerParticleManager.current_step_particle:
            run_list.select(run_particle_ids.size())
          run_particle_ids.append(particle.id)

func _on_jump_list_selected(index: int) -> void:
  player.jump_player()
  PlayerParticleManager.current_jump_particle = jump_particle_ids[index]

func _on_run_particle_list_selected(index: int) -> void:
  PlayerParticleManager.current_step_particle = run_particle_ids[index]

func _on_back_button_pressed() -> void:
  visible = false
  camera_animation_player.play_backwards("zoom_particles")
  main_menu.visible = true
  await camera_animation_player.animation_finished
  main_menu.animation_player.play("enter")
