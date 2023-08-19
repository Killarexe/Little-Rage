extends Node

var enable_discord_rpc: bool = true

var discord := DiscordRPC.new()

func update_rpc(state: String, small_image: String, small_image_text: String):
	if !enable_discord_rpc || Global.is_mobile:
		return
	await discord.update_presence({
		state = state,
		assets = {
			small_image = small_image,
			small_image_text = small_image_text
		}
	})

func _ready():
	print("Running Discord RPC...")
	process_mode = Node.PROCESS_MODE_ALWAYS
	if !enable_discord_rpc || Global.is_mobile:
		return
	add_child(discord)
	discord.rpc_ready.connect(on_rpc_ready)
	discord.rpc_error.connect(on_rpc_error)
	discord.establish_connection(807516321830666292)
	update_rpc("Playing...", "basicicon", "Playing...")

func on_rpc_ready(user: Dictionary):
	print("Discord User found:")
	print(user)
	discord.update_presence(
		RichPresenceBuilder.new()\
			.with_details("A Small Simple 2D Platformer made by Killar.exe")\
			.with_large_image("icon")\
			.with_large_text("Little Rage")\
			.start_timestamp(int(Time.get_unix_time_from_system()))\
			.build()
	)

func on_rpc_error(error: int):
	print("Failed to update/load Discord RPC. Error %s" % error)
