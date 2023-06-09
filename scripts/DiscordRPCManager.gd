extends Node
class_name DiscordRPCManager

func update(state: String, small_image: String, small_image_text: String):
	discord_sdk.state = state
	discord_sdk.small_image = small_image
	discord_sdk.small_image_text = small_image_text
	if !discord_sdk.get_is_discord_working():
		print("Can't run Discord RPC: No Discord found...")
		return
	print("Running Discord RPC...")
	discord_sdk.refresh()

#TODO: Level complete!
func _ready():
	discord_sdk.debug()
	discord_sdk.app_id = 807516321830666292
	discord_sdk.details = "MY GAMME!!!"
	discord_sdk.large_image = "icon"
	discord_sdk.large_image_text = "Little Rage"
	discord_sdk.start_timestamp = int(Time.get_unix_time_from_system())
	#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system())
	update("Playing...", "basicicon", "Playing...")
