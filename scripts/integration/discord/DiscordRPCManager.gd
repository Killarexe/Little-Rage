extends Node

var enable_discord_rpc: bool = true

func update_rpc(state: String, small_image: String, small_image_text: String):
	if enable_discord_rpc && !Global.is_mobile && discord_sdk.get_is_discord_working():
		discord_sdk.state = state
		discord_sdk.small_image = small_image
		discord_sdk.small_image_text = small_image_text
		discord_sdk.refresh()

func _ready():
	if enable_discord_rpc && !Global.is_mobile && discord_sdk.get_is_discord_working():
		discord_sdk.app_id = 807516321830666292 # Application ID
		discord_sdk.details = "A Small Simple 2D Platformer made by Killar.exe"
		discord_sdk.state = "Doing nothing..."
		
		discord_sdk.large_image = "icon"
		discord_sdk.large_image_text = "Little Rage"
	
		discord_sdk.start_timestamp = int(Time.get_unix_time_from_system())
		
		discord_sdk.refresh()
	
