extends ItemList

signal on_selected(achievement: Achievement)

func _ready():
	for achievement in AchievementManager.achievements:
		var icon: Texture2D = achievement.icon
		if !AchievementManager.unlocked_achievements.has(achievement.id):
			icon = load("res://assets/textures/achievement_icons/default.png")
		add_icon_item(icon, AchievementManager.has_unlocked_achievement(achievement.id))

func _on_item_selected(index: int):
	var achievement: Achievement = AchievementManager.achievements[index]
	if AchievementManager.has_unlocked_achievement(achievement.id):
		on_selected.emit(achievement)
