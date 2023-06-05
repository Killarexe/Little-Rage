class_name DiscordRPCManager

func update(state: String, small_image: String, small_image_text: String):
	discord_sdk.state = state
	discord_sdk.small_image = small_image
	discord_sdk.small_image_text = small_image_text
	discord_sdk.refresh()

func start():
	discord_sdk.app_id = 807516321830666292
	print("DiscordRPC setup status: " + str(discord_sdk.get_is_discord_working()))
	discord_sdk.details = "Little Rage"
	discord_sdk.large_image = "icon"
	discord_sdk.large_image_text = "Little Rage"
	discord_sdk.start_timestamp = int(Time.get_unix_time_from_system())
	update("Playing...", "basicicon", "Playing...")
