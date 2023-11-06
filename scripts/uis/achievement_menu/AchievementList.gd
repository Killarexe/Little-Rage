extends ItemList

signal on_selected(achievement: Achievement)

func _ready():
	for achievement in AchievementManager.achievements:
		add_icon_item(achievement.icon, AchievementManager.has_unlocked_achievement(achievement.id))

func _on_item_selected(index: int):
	var achievement: Achievement = AchievementManager.achievements[index]
	if AchievementManager.has_unlocked_achievement(achievement.id):
		on_selected.emit(achievement)
