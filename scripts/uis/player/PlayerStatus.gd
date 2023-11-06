extends CanvasLayer

@onready var ragequit_button: Button = $VBoxContainer/RageQuitButton
@onready var deaths_label: Label = $VBoxContainer/DeathsLabel
@onready var time_label: Label = $VBoxContainer/TimeLabel
@export var player: PlayerMovement
@export var timer: PlayerTimer

func _ready():
	visible = player.controllable
	player.on_death.connect(on_death)
	timer.timeout.connect(on_timeout)
	deaths_label.text = TranslationServer.translate("label.deaths") + ": 0"
	time_label.text = TranslationServer.translate("label.time") + ": 00:00:00"

func on_death(death_count: int):
	if death_count == 10:
		ragequit_button.visible = true
	else:
		ragequit_button.visible = false
	AchievementManager.unlock_achievement("first_death")
	deaths_label.text = TranslationServer.translate("label.deaths") + ": " + str(death_count)

func on_timeout():
	var time: Array[int] = timer.get_time()
	time_label.text = TranslationServer.translate("label.time") + ": " + str(time[0]).pad_zeros(2) + ":" + str(time[1]).pad_zeros(2) + ":" + str(time[2]).pad_zeros(2)

func _on_rage_quit_button_pressed():
	Achievement.unlock_achievement("rage_quit")
	get_tree().quit()
