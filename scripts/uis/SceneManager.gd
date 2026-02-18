extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: ColorRect = $Texture

func prepare() -> void:
  texture_rect.mouse_filter = Control.MOUSE_FILTER_STOP
  texture_rect.modulate = Color.WHITE
  texture_rect.visible = true
  texture_rect.color = RenderingServer.get_default_clear_color()

func end() -> void:
  texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
  texture_rect.visible = false
  texture_rect.position = Vector2(0, 0)

func play_animation(transition_type: int, inverse: bool) -> bool:
  var speed: float = 1.0
  if inverse:
    speed = -1.0
  var animation_names: PackedStringArray = animation_player.get_animation_list()
  if transition_type < animation_names.size():
    animation_player.play(animation_names[transition_type], -1, speed, inverse)
    return true
  return false

func change_scene(path: String, in_anim_id: int = 2, is_in_anim_inv: bool = false, out_anim_id: int = 3, is_out_anim_inv: bool = false) -> void:
  if animation_player.is_playing():
    return
  prepare()
  if play_animation(in_anim_id, is_in_anim_inv):
    await animation_player.animation_finished
  get_tree().change_scene_to_file(path)
  if play_animation(out_anim_id, is_out_anim_inv):
    await animation_player.animation_finished
  end()

func change_packed(packed: PackedScene, in_anim_id: int = 2, is_in_anim_inv: bool = false, out_anim_id: int = 3, is_out_anim_inv: bool = false) -> void:
  if animation_player.is_playing():
    return
  prepare()
  if play_animation(in_anim_id, is_in_anim_inv):
    await animation_player.animation_finished
  get_tree().change_scene_to_packed(packed)
  if play_animation(out_anim_id, is_out_anim_inv):
    await animation_player.animation_finished
  end()
