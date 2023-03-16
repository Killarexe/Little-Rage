extends Label

var timer_milliseconds: int = 0
var timer_minutes: int = 0
var timer_seconds: int = 0

func update_timer():
	if timer_milliseconds > 59:
		timer_seconds += 1
		timer_milliseconds = 0
	if timer_seconds > 59:
		timer_minutes += 1
		timer_seconds = 0
	text = "Time: " + str(timer_minutes).pad_zeros(2) + ":" + str(timer_seconds).pad_zeros(2) + ":" +str(timer_milliseconds).pad_zeros(2)

func _on_timer_timeout():
	timer_milliseconds += 1;
	update_timer();
