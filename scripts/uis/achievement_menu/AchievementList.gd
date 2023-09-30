extends ItemList

signal on_selected(achievement: Achievement)

func _ready():
	for achievement in AchievementManager.achievements:
		add_icon_item(achievement.icon)

func _on_item_selected(index: int):
	on_selected.emit(AchievementManager.achievements[index])
