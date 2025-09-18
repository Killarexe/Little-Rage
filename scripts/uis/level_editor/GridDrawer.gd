@tool
extends Node2D
class_name GridDrawer

@export var camera: Camera2D
@export var tile_size: int = 16
@export var offset: int = 100

var viewport_rect: Rect2

func _ready() -> void:
  viewport_rect = get_viewport_rect()

func _process(_delta: float) -> void:
  if visible && camera != null:
    queue_redraw()

func _draw() -> void:
  var camera_pos: Vector2 = camera.position
  var grid_size: Vector2 = viewport_rect.size / camera.zoom
  var distance: Vector2i = camera_pos - grid_size
  var rev_distance: Vector2i = camera_pos + grid_size
  for i in range(distance.x / tile_size - 1, rev_distance.x / tile_size + 1):
    var x: int = i * tile_size
    draw_line(Vector2(x, rev_distance.y + offset), Vector2(x, distance.y - offset), Color.BLACK)
  for i in range(distance.y / tile_size - 1, rev_distance.y / tile_size + 1):
    var y: int = i * tile_size
    draw_line(Vector2(rev_distance.x + offset, y), Vector2(distance.x - offset, y), Color.BLACK)
