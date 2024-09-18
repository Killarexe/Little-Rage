extends Control

@export var icon: TextureRect
@export var achievement_label: Label
@export var description: RichTextLabel
@export var animation_player: AnimationPlayer

var selected_achievement: Achievement = null

func _on_achievement_list_on_selected(achievement: Achievement) -> void:
	selected_achievement = achievement
	animation_player.queue("change_information")

func update_achievement_description() -> void:
	if selected_achievement != null:
		if AchievementManager.unlocked_achievements.has(selected_achievement.id):
			icon.texture = selected_achievement.icon
		else:
			icon.texture = load("res://assets/textures/achievement_icons/default.png")
		description.text = TranslationServer.translate("achievement.%s.desc" % selected_achievement.id)
		achievement_label.text = TranslationServer.translate("achievement." + selected_achievement.id)
