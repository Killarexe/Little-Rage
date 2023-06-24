extends HTTPRequest

signal on_update_checked(flag: GameVersion.GameVersionFlag)

func _ready():
	request_completed.connect(on_receive)
	request("https://api.github.com/repos/Killarexe/Little-Rage/releases/latest")

func on_receive(_result, response_code, _headers, body):
	if response_code < 400:
		var version_name: String = JSON.parse_string(body.get_string_from_utf8())["name"]
		var version: GameVersion = GameVersion.from_string(version_name)
		var version_flag: GameVersion.GameVersionFlag = Global.GAME_VERSION.compare(version)
		emit_signal("on_update_checked", version_flag)
	else:
		print("Failed to get latest version: Response code: %d" % response_code)
	request_completed.disconnect(on_receive)
