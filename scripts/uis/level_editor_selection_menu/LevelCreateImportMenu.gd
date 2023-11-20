extends Control

@onready var level_creation_menu: LevelSettingsMenu = $LevelCreation
@onready var level_import_menu: Control = $ImportMenu

func _on_create_button_pressed():
	#TODO: Add animation
	level_creation_menu.visible = true

func _on_import_button_pressed():
	#TODO: Add animation 
	level_import_menu.visible = true

func _on_create_level_button_pressed():
	pass	#TODO: Create Level

func _on_back_button_pressed():
	#TODO: Add Animation
	visible = false
