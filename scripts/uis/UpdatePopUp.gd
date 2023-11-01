extends CanvasLayer

@onready var window: Window = $Window
@onready var http_request: HTTPRequest = $HTTPRequest
@onready var rich_text_label: RichTextLabel = $Window/TextLabel

func _ready():
	#window.popup_centered()
	http_request.request("https://api.github.com/repos/Killarexe/Little-Rage/releases/latest")

func _on_http_request_request_completed(result: int, response_code: int, headers, body):
	if response_code < 400 && result == HTTPRequest.RESULT_SUCCESS:
		var releases_notes: String = JSON.parse_string(body.get_string_from_utf8())["body"]
		rich_text_label.add_text(releases_notes)
	else:
		print("Failed to get latest version:\n\tResponse code: " + str(response_code) + "\n\tResult: " + str(result))
