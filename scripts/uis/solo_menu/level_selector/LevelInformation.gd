extends Control

@onready var label: RichTextLabel = $Description

@onready var difficulty_label: Label = $DifficultyLabel
@onready var difficulty_color: ColorRect = $DifficultyLabel/ColorRect
@onready var record_label: Label = $RecordLabel

func _on_level_list_on_level_selected(level: Level):
	if LevelManager.is_default_level(level.id):
		label.text = TranslationServer.translate(level.description)
	else:
		label.text = level.description
	record_label.text = TranslationServer.translate("label.best_time") + ": " + LevelManager.get_level_best_time_as_str(level.id)
	difficulty_label.text = TranslationServer.translate(Level.difficulty_to_str(level.difficulty))
