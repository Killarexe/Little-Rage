extends Control

@onready var icon: TextureRect = $AchievementIcon
@onready var description: RichTextLabel = $AchievementDescription

func _on_achievement_list_on_selected(achievement: Achievement):
	if AchievementManager.unlocked_achievements.has(achievement.id):
		icon.texture = achievement.icon
	else:
		icon.texture = load("res://assets/textures/achievement_icons/default.png")
	description.text = TranslationServer.translate("achievement.%s.desc" % achievement.id)

func _on_back_button_pressed():
	SceneManager.change_scene("res://scenes/uis/CollectionsMenu.tscn")
