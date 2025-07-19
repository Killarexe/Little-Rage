extends Node

const SELECT_SFX: AudioStream = preload("res://assets/sound_effects/button_select.ogg")
const CLICK_SFX: AudioStream = preload("res://assets/sound_effects/button_click.ogg")

var playback: AudioStreamPlaybackPolyphonic

func _enter_tree() -> void:
  var player: SoundEffectPlayer = SoundEffectPlayer.new()
  add_child(player)
  player.bus = "Sound Effects"
  
  var stream: AudioStreamPolyphonic = AudioStreamPolyphonic.new()
  stream.polyphony = 32
  player.stream = stream
  player.play()
  playback = player.get_stream_playback()
  get_tree().node_added.connect(on_node_added)
  
func on_node_added(node: Node) -> void:
  if node is Button:
    node.mouse_entered.connect(play_hover)
    node.pressed.connect(play_click)
    
func play_hover() -> void:
  playback.play_stream(SELECT_SFX, 0.0, 0.0, randf_range(0.9, 1.1))

func play_click() -> void:
  playback.play_stream(CLICK_SFX, 0.0, 0.0, randf_range(0.9, 1.1))
