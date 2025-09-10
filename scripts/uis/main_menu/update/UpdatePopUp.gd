extends CanvasLayer

#INFO: This code is unused for now!
#NOTE: This code is still unused after 2 years! I don't think this code will be ever used!

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var rich_text_label: RichTextLabel = $Window/TextLabel

func _ready() -> void:
  http_request.request("https://api.github.com/repos/Killarexe/Little-Rage/releases/latest")

func _on_http_request_request_completed(result: int, response_code: int, _headers, body) -> void:
  if response_code < 400 && result == HTTPRequest.RESULT_SUCCESS:
    var version_name: String = JSON.parse_string(body.get_string_from_utf8())["name"]
    var version: GameVersion = GameVersion.from_string(version_name)
    var version_flag: GameVersion.GameVersionFlag = Game.GAME_VERSION.compare(version)
    if version_flag == GameVersion.GameVersionFlag.HIGHER:
      PopUpFrame.pop_translated("message.update", load("res://assets/textures/ui/icons/update.png"))
  else:
    print("Failed to get latest version:\n\tResponse code: " + str(response_code) + "\n\tResult: " + str(result))
