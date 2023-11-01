extends Control

@onready var label: RichTextLabel = $Description/Background/Label

@onready var difficulty_label: Label = $Difficulty/ColorRect/Label
@onready var difficulty_color: ColorRect = $Difficulty/ColorRect

func _on_levels_list_on_level_selected(level: Level):
	if LevelManager.is_default_level(level.id):
		label.text = TranslationServer.translate(level.description)
	else:
		label.text = level.description
	difficulty_label.text = TranslationServer.translate(Level.difficulty_to_str(level.difficulty))
