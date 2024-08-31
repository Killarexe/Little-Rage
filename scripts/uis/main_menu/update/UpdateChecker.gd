extends HTTPRequest

signal on_update_checked(flag: GameVersion.GameVersionFlag)

func _ready() -> void:
	request_completed.connect(on_receive)
	request("https://api.github.com/repos/Killarexe/Little-Rage/releases/latest")

func on_receive(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code < 400 && result == RESULT_SUCCESS:
		var version_name: String = JSON.parse_string(body.get_string_from_utf8())["name"]
		var version: GameVersion = GameVersion.from_string(version_name)
		var version_flag: GameVersion.GameVersionFlag = Game.GAME_VERSION.compare(version)
		print_rich("[color=lightgreen][i]Current game version: %s [/i][/color]" % Game.GAME_VERSION.as_str())
		print_rich("[color=lightgreen][i]Latest game version: %s [/i][/color]" % version.as_str())
		if version_flag == GameVersion.GameVersionFlag.HIGHER:
			PopUpFrame.pop_translated("message.update", load("res://assets/textures/ui/icons/update.png"))
		elif version_flag == GameVersion.GameVersionFlag.LOWER:
			AchievementManager.unlock_achievement("beta_tester")
		on_update_checked.emit(version_flag)
	else:
		print_rich("[color=red][b]Failed to get latest version:\n\tResponse code: " + str(response_code) + "\n\tResult: " + str(result) + " [/b][/color]")
	request_completed.disconnect(on_receive)
	queue_free()
