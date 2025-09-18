extends Node

const SAVE_FILE: String = "user://save.json"
const DEFAULT_SAVE: Dictionary = {
  "unlocked_hats": ["no_hat"],
  "unlocked_skins": ["default"],
  "unlocked_particles": ["default_jump", "default_death", "default_step"],
  "unlocked_achievements": [],
  "current_skin": "default",
  "current_hat": "no_hat",
  "current_death_particle": "default_death",
  "current_jump_particle": "default_jump",
  "current_step_particle": "default_step",
  "level_times": {},
  "music_volume": 75.0,
  "sound_effects_volume": 25.0,
  "loot_box_count": 0,
  "window_size": 5,
  "lang": "en",
  "death_count": 0
}

func _ready() -> void:
  load_save()

func save() -> void:
  if !FileAccess.file_exists(SAVE_FILE):
    create_save()
  var save_file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
  var data: Dictionary = DEFAULT_SAVE.duplicate()
  
  data["window_size"] = WindowManager.window_size
  data["lang"] = TranslationServer.get_locale()
  data["music_volume"] = MusicManager.music_volume
  data["current_hat"] = PlayerHatManager.current_hat
  data["level_times"] = LevelManager.levels_best_times
  data["current_skin"] = PlayerSkinManager.current_skin
  data["unlocked_hats"] = PlayerHatManager.unlocked_hats
  data["unlocked_skins"] = PlayerSkinManager.unlocked_skins
  data["loot_box_count"] = LootBoxesManager.loot_box_count
  data["sound_effects_volume"] = MusicManager.sound_effect_volume
  data["unlocked_achievements"] = AchievementManager.unlocked_achievements
  data["unlocked_particles"] = PlayerParticleManager.unlocked_particles
  data["current_death_particle"] = PlayerParticleManager.current_death_particle
  data["current_jump_particle"] = PlayerParticleManager.current_jump_particle
  data["current_step_particle"] = PlayerParticleManager.current_step_particle
  save_file.store_string(JSON.stringify(data, "  "))
  save_file.close()

func create_save() -> void:
  var save_file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
  save_file.store_string(JSON.stringify(DEFAULT_SAVE))
  save_file.close()

func get_or_default(data: Dictionary, index: String) -> Variant:
  return data.get(index, DEFAULT_SAVE[index])

func load_save() -> void:
  if !FileAccess.file_exists(SAVE_FILE):
    create_save()
  var save_file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.READ)
  var data = JSON.parse_string(save_file.get_as_text())
  if data is Dictionary:
    WindowManager.window_size = get_or_default(data, "window_size")
    TranslationServer.set_locale(get_or_default(data, "lang"))
    PlayerHatManager.current_hat = get_or_default(data, "current_hat")
    LevelManager.levels_best_times = get_or_default(data, "level_times")
    PlayerSkinManager.current_skin = get_or_default(data, "current_skin")
    PlayerHatManager.unlocked_hats = get_or_default(data, "unlocked_hats")
    PlayerSkinManager.unlocked_skins = get_or_default(data, "unlocked_skins")
    LootBoxesManager.loot_box_count = get_or_default(data, "loot_box_count")
    AchievementManager.unlocked_achievements = get_or_default(data, "unlocked_achievements")
    PlayerParticleManager.unlocked_particles = get_or_default(data, "unlocked_particles")
    PlayerParticleManager.current_death_particle = get_or_default(data, "current_death_particle")
    PlayerParticleManager.current_jump_particle = get_or_default(data, "current_jump_particle")
    PlayerParticleManager.current_step_particle = get_or_default(data, "current_step_particle")
    MusicManager.sound_effect_volume = get_or_default(data, "sound_effects_volume")
    MusicManager.set_music_volume(get_or_default(data, "music_volume"))
  else:
    create_save()

func reset_save():
  create_save()
  load_save()
