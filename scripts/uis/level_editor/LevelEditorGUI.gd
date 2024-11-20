extends CanvasLayer
class_name LevelEditorGUI

@export_category("Required Components")
@export var level: LevelPlayer
@export var camera: Camera2D

@export_category("Menu UIs")
@export var menu: LevelEditorMenu
@export var menu_button: Button
@export var menu_animation_player: AnimationPlayer

@export_category("Tiles UIs")
@export var tiles_button: Button
@export var tiles_list: TilesList
@export var tiles_list_animation_player: AnimationPlayer

@export_category("Global buttons")
@export var center_button: Button

func _ready() -> void:
	if !tiles_list.is_node_ready():
		await tiles_list.ready
	tiles_list.create_list(level.ground.tile_set.get_source(1).texture)
	tiles_button.pressed.connect(on_tiles_button_pressed)
	menu_button.pressed.connect(on_menu_button_pressed)
	center_button.pressed.connect(on_center_button_pressed)
	
	tiles_list.visible = false

func on_center_button_pressed() -> void:
	camera.position = Vector2.ZERO

func on_tiles_button_pressed() -> void:
	if tiles_list.visible:
		tiles_list_animation_player.play("TilesListAnimations/hide")
	else:
		if menu.visible:
			menu_animation_player.play_backwards("Menu/show")
		tiles_list_animation_player.play("TilesListAnimations/show")

func on_menu_button_pressed() -> void:
	if menu.visible:
		menu_animation_player.play_backwards("Menu/show")
	else:
		if tiles_list.visible:
			tiles_list_animation_player.play("TilesListAnimations/hide")
		menu_animation_player.play("Menu/show")
