extends Node

const ACHIEVEMENT_DIR: String = "res://data/achievements"

var achievements: Array[Achievement] = []
var unlocked_achievements: Array = []

func _ready():
	var resources: Array[ResourceElement] = DataLoader.new().load_data_in_dir(ACHIEVEMENT_DIR, "achievement")
	for resource in resources:
		if resource is Achievement:
			achievements.append(resource)

func unlock_achievement(achievement_id: String):
	if unlocked_achievements.has(achievement_id):
		return
	for achievement in achievements:
		if achievement.id == achievement_id:
			unlocked_achievements.append(achievement_id)
			PopUpFrame.pop(TranslationServer.translate("popup.unlocked_achievement") % TranslationServer.translate("achievement." + achievement_id), achievement.icon)
			SaveManager.save()
			return
	print_rich("[color=red][b]Failed to unlock achievement: %s[/b][/color]" % achievement_id)

func has_unlocked_achievement(achievement_id: String) -> bool:
	return unlocked_achievements.has(achievement_id)
