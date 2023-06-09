extends Node

#TODO: Translated states...
func update_rpc(state: String, small_image: String, small_image_text: String):
	discord_sdk.state = state
	discord_sdk.small_image = small_image
	discord_sdk.small_image_text = small_image_text
	discord_sdk.refresh()

#TODO: Level complete!
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	discord_sdk.debug()
	discord_sdk.app_id = 807516321830666292
	discord_sdk.details = "A Small Simple 2D Platformer made by Killar.exe"
	discord_sdk.large_image = "icon"
	discord_sdk.large_image_text = "Little Rage"
	discord_sdk.start_timestamp = int(Time.get_unix_time_from_system())
	#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system())
	if !discord_sdk.get_is_discord_working():
		print("Can't run Discord RPC: No Discord found...")
		return
	print("Running Discord RPC...")
	update_rpc("Playing...", "basicicon", "Playing...")
