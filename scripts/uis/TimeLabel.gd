extends Label
class_name TimeLabel

var timer_mins: int = 0
var timer_secs: int = 0
var timer_millis: int = 0
var coins: int = 0
var score: int = 0
var deaths: int = 0
var best_time: bool = false
var show_zeros: bool = false

func _ready():
	visible = false

func start(timer: Array[int], death_count: int, is_best_time: bool):
	visible = true
	for i in timer[2]:
		timer_millis = i
		update_text()
		await get_tree().create_timer(0.01).timeout
	for i in timer[1]:
		timer_secs = i
		update_text()
		await get_tree().create_timer(0.01).timeout
	for i in timer[0]:
		timer_mins = i
		update_text()
		await get_tree().create_timer(0.01).timeout
	await get_tree().create_timer(0.5).timeout
	await get_tree().create_timer(0.5).timeout
	show_zeros = true
	best_time = is_best_time
	update_text()

func update_text():
	var time_str: String = "Time: " + str(timer_mins).pad_zeros(2) + ":" + str(timer_secs).pad_zeros(2) + ":" + str(timer_millis).pad_zeros(2)
	var deaths_str: String = "\nDeaths: "
	if best_time:
		time_str += "    Best time!"
	if deaths > 0 || show_zeros:
		deaths_str += str(deaths)
	text = time_str + deaths_str
