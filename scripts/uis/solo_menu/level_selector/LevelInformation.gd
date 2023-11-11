extends Control
class_name LevelDescription

@export var record_label: Label
@export var description: RichTextLabel
@export var difficulty_label: Label
@export var difficulty_color: ColorRect

func _on_level_list_on_level_selected(level: Level):
	if LevelManager.is_default_level(level.id):
		description.text = TranslationServer.translate(level.description)
	else:
		description.text = level.description
	record_label.text = TranslationServer.translate("label.best_time") + ": " + LevelManager.get_level_best_time_as_str(level.id)
	difficulty_label.text = TranslationServer.translate(Level.difficulty_to_str(level.difficulty))
	difficulty_color.color = get_color_from_difficulty(level.difficulty)

func get_color_from_difficulty(difficulty: Level.Difficulty) -> Color:
	match difficulty:
		Level.Difficulty.BEGINER_FRIENDLY:
			return Color.LIME_GREEN
		Level.Difficulty.EASY:
			return Color.SEA_GREEN
		Level.Difficulty.NORMAL:
			return Color.GREEN_YELLOW
		Level.Difficulty.HARD:
			return Color.ORANGE_RED
		Level.Difficulty.EXTREME:
			return Color.RED
	return Color.SEA_GREEN
