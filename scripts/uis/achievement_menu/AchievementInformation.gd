extends Control

@onready var icon: TextureRect = $AchievementIcon
@onready var description: RichTextLabel = $AchievementDescription

func _on_achievement_list_on_selected(achievement: Achievement):
	icon.texture = achievement.icon
	description.text = TranslationServer.translate("achievement.%s.desc" % achievement.id)

func _on_back_button_pressed():
	SceneManager.change_scene("res://scenes/uis/CollectionsMenu.tscn")
