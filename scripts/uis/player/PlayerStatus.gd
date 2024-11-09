extends CanvasLayer
class_name PlayerStatus

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ragequit_button: Button = $RageQuitButton
@onready var deaths_label: Label = $DeathsLabel
@onready var time_label: Label = $TimeLabel
@export var player: PlayerComponent
@export var player_skin: PlayerSkinSprite
@export var timer: PlayerTimer

func _ready() -> void:
	player.death_component.on_death.connect(on_death)
	timer.timeout.connect(on_timeout)
	deaths_label.text = TranslationServer.translate("label.deaths") + ": 0"
	time_label.text = TranslationServer.translate("label.time") + ": 00:00:00"

func on_death(death_count: int) -> void:
	animation_player.play("update_death_counter")
	if death_count % 10 == 0:
		animation_player.play("pop_ragequit_button")
	elif ragequit_button.visible:
		animation_player.play_backwards("pop_ragequit_button")
	
	if death_count == 25:
		PlayerSkinManager.unlock_skin("injured_player")
		AchievementManager.unlock_achievement("invincible")
		player_skin.texture = PlayerSkinManager.get_skin("injured_player").texture
	AchievementManager.unlock_achievement("first_death")
	deaths_label.text = TranslationServer.translate("label.deaths") + ": " + str(death_count)

func on_timeout() -> void:
	var time: Array[int] = timer.get_time()
	time_label.text = TranslationServer.translate("label.time") + ": " + str(time[0]).pad_zeros(2) + ":" + str(time[1]).pad_zeros(2) + ":" + str(time[2]).pad_zeros(2)

func _on_rage_quit_button_pressed() -> void:
	AchievementManager.unlock_achievement("rage_quit")
	get_tree().quit()
