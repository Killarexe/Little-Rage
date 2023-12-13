extends Control

@onready var icon: TextureRect = $AchievementIcon
@onready var achievement_label: Label = $AchievementName
@onready var description: RichTextLabel = $ColorRect/AchievementDescription
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var selected_achievement: Achievement = null

func _on_achievement_list_on_selected(achievement: Achievement):
	selected_achievement = achievement
	animation_player.queue("change_information")

func update_achievement_description():
	if selected_achievement != null:
		if AchievementManager.unlocked_achievements.has(selected_achievement.id):
			icon.texture = selected_achievement.icon
		else:
			icon.texture = load("res://assets/textures/achievement_icons/default.png")
		description.text = TranslationServer.translate("achievement.%s.desc" % selected_achievement.id)
		achievement_label.text = TranslationServer.translate("achievement." + selected_achievement.id)
