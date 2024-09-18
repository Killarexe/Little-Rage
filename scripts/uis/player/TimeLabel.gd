extends Label
class_name TimeLabel

signal on_terminated()

var timer_mins: int = 0
var timer_secs: int = 0
var timer_millis: int = 0
var coins: int = 0
var score: int = 0
var deaths: int = 0
var show_zeros: bool = false

func _ready() -> void:
	visible = false

#TODO: This code fucking sucks. This really needs to be changed!
func start(timer: Array[int], death_count: int) -> void:
	visible = true
	for i in timer[2] + 1:
		timer_millis = i
		update_text()
		await get_tree().create_timer(0.01).timeout
	for i in timer[1] + 1:
		timer_secs = i
		update_text()
		await get_tree().create_timer(0.01).timeout
	for i in timer[0] + 1:
		timer_mins = i
		update_text()
		await get_tree().create_timer(0.01).timeout
	await get_tree().create_timer(0.5).timeout
	await get_tree().create_timer(0.5).timeout
	show_zeros = true
	deaths = death_count
	update_text()
	on_terminated.emit()

func update_text() -> void:
	var time_str: String = TranslationServer.translate("label.time") + ": " + str(timer_mins).pad_zeros(2) + ":" + str(timer_secs).pad_zeros(2) + ":" + str(timer_millis).pad_zeros(2)
	var deaths_str: String = "\n" + TranslationServer.translate("label.deaths") + ": "
	if deaths > 0 || show_zeros:
		deaths_str += str(deaths)
	text = time_str + deaths_str
