extends CanvasLayer

@export var spawn_pos: Node2D

var popup_scene: PackedScene = preload("res://scenes/bundles/uis/PopUp.tscn")
var popups: Array[PopUp] = []
var current_popup: PopUp

func pop_translated(message: String, icon_texture: Texture2D = null, on_pressed: Callable = func():pass) -> void:
	pop(TranslationServer.translate(message), icon_texture, on_pressed)

func pop(message: String, icon_texture: Texture2D = null, on_pressed: Callable = func():pass) -> void:
	var popup: PopUp = popup_scene.instantiate()
	popup.text.text = message
	popup.icon.texture = icon_texture
	popup.on_pressed = on_pressed
	popups.append(popup)
	spawn_popup()

func spawn_popup():
	if current_popup != null:
		await current_popup.animation_player.animation_finished
	current_popup = popups.pop_front()
	spawn_pos.add_child(current_popup)
	await current_popup.animation_player.animation_finished
	current_popup = null
