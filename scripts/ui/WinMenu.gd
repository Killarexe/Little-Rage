extends Control

var timer_mins: int = 0
var timer_secs: int = 0
var timer_millis: int = 0
var best_time: bool = false

func _ready():
	pass

func start(player, timer):
	visible = true
	timer_mins = timer.timer_minutes
	timer_secs = timer.timer_seconds
	timer_millis = timer.timer_milliseconds
	
	for i in timer_millis:
		set_text(0, 0, i, 0, 0, 0)
		await get_tree().create_timer(0.01).timeout
	for i in timer_secs:
		set_text(0, i, timer_millis, 0, 0, 0)
		await get_tree().create_timer(0.01).timeout
	for i in timer_mins:
		set_text(i, timer_secs, timer_millis, 0, 0, 0)
		await get_tree().create_timer(0.01).timeout
	await get_tree().create_timer(0.5).timeout
	
	var time = int(str(timer_mins) + str(timer_secs) + str(timer_millis))
	if LevelManager.get_level_best_time(LevelManager.currentLevel) >= time:
		LevelManager.set_level_best_time(timer_mins, timer_secs, timer_secs)
		best_time = true
	
	for i in 5:
		set_text(timer_mins, timer_secs, timer_millis, i, 0, 0)
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(0.5).timeout
	
	for i in player.deathCount:
		set_text(timer_mins, timer_secs, timer_millis, 5, i, 0)
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(0.5).timeout
	set_text(timer_mins, timer_secs, timer_millis, 5, player.deathCount, 0, true)

func set_text(time_min: int, time_secs:int, time_milis: int, coins: int, deaths: int, score:int, show_zeros: bool = false):
	var time_str: String = "Time: " + str(time_min).pad_zeros(2) + ":" + str(time_secs).pad_zeros(2) + ":" + str(time_milis).pad_zeros(2)
	var coins_str: String = "\nCoins: "
	var deaths_str: String = "\nDeaths: "
	var score_str: String = "\nTotal Score: "
	if best_time:
		time_str += "    Best time!"
	if coins > 0 || show_zeros:
		coins_str += str(coins)
	if deaths > 0 || show_zeros:
		deaths_str += str(deaths)
	if score > 0 || show_zeros:
		score_str += str(score)
	$Results.text = time_str + coins_str + deaths_str + score_str

func _on_ContinueButton_pressed():
	get_tree().paused = false
	LevelManager.unlock_next_level()
	Global.addCoins(5)
	SceneTransition.change_scene_to_file("res://scenes/ui/MainMenu.tscn")
