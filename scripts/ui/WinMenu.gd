extends Control

func _ready():
	pass

func start(player):
	visible = true
	for i in player.timer_milliseconds:
		set_text(0, 0, i, 0, 0, 0)
		yield(get_tree().create_timer(0.01), "timeout")
	for i in player.timer_seconds:
		set_text(0, i, player.timer_milliseconds, 0, 0, 0)
		yield(get_tree().create_timer(0.01), "timeout")
	for i in player.timer_minutes:
		set_text(i, player.timer_seconds, player.timer_milliseconds, 0, 0, 0)
		yield(get_tree().create_timer(0.01), "timeout")
	yield(get_tree().create_timer(0.5), "timeout")
	for i in 5:
		set_text(player.timer_minutes, player.timer_seconds, player.timer_milliseconds, i, 0, 0)
		yield(get_tree().create_timer(0.1), "timeout")
	yield(get_tree().create_timer(0.5), "timeout")
	
	for i in player.deathCount:
		set_text(player.timer_minutes, player.timer_seconds, player.timer_milliseconds, 5, i, 0)
		yield(get_tree().create_timer(0.1), "timeout")
	yield(get_tree().create_timer(0.5), "timeout")
	set_text(player.timer_minutes, player.timer_seconds, player.timer_milliseconds, 5, player.deathCount, 0, true)

func set_text(time_min: int, time_secs:int, time_milis: int, coins: int, deaths: int, score:int, show_zeros: bool = false):
	var time_str: String = "Time: " + str(time_min).pad_zeros(2) + ":" + str(time_secs).pad_zeros(2) + ":" + str(time_milis).pad_zeros(2)
	var coins_str: String = "\nCoins: "
	var deaths_str: String = "\nDeaths: "
	var score_str: String = "\nTotal Score: "
	if coins > 0 || show_zeros:
		coins_str += str(coins)
	if deaths > 0 || show_zeros:
		deaths_str += str(deaths)
	if score > 0 || show_zeros:
		score_str += str(score)
	$Results.text = time_str + coins_str + deaths_str + score_str

func _on_ContinueButton_pressed():
	get_tree().paused = false
	Global.unlockNextLevel()
	Global.addCoins(5)
	SceneTransition.change_scene("res://scenes/ui/MainMenu.tscn")
