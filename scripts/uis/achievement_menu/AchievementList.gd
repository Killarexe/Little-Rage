extends ItemList

signal on_selected(achievement: Achievement)

var achievement_list: Array[int] = []

func _ready() -> void:
	var index: int = 0
	for achievement in AchievementManager.achievements:
		var unlocked: bool = AchievementManager.unlocked_achievements.has(achievement.id)
		if !(achievement.hidden && !unlocked):
			var icon: Texture2D = achievement.icon
			if !unlocked:
				icon = load("res://assets/textures/achievement_icons/default.png")
			achievement_list.append(index)
			add_icon_item(icon)
		index += 1
	_on_item_selected.call_deferred(achievement_list[0])

func _on_item_selected(index: int) -> void:
	var achievement: Achievement = AchievementManager.achievements[achievement_list[index]]
	on_selected.emit(achievement)
