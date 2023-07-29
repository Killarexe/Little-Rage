extends CanvasLayer

@onready var deaths_label: Label = $VBoxContainer/DeathsLabel
@onready var time_label: Label = $VBoxContainer/TimeLabel
@export var player: PlayerMovement
@export var timer: PlayerTimer

func _ready():
	player.on_death.connect(on_death)
	timer.timeout.connect(on_timeout)

func on_death(death_count: int):
	deaths_label.text = TranslationServer.translate("ui.deaths") + ": " + str(death_count)

func on_timeout():
	var time: Array[int] = timer.get_time()
	time_label.text = TranslationServer.translate("ui.time") + ": " + str(time[0]).pad_zeros(2) + ":" + str(time[1]).pad_zeros(2) + ":" + str(time[2]).pad_zeros(2)
