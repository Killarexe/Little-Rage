extends Control

@onready var result_text = $Results

var timer_mins: int = 0
var timer_secs: int = 0
var timer_millis: int = 0
var coins: int = 0
var score: int = 0
var deaths: int = 0
var best_time: bool = false
var show_zeros: bool = false

func start(player, timer):
	visible = true
	
	for i in timer.timer_milliseconds:
		timer_millis = i
		update_text()
		await get_tree().create_timer(0.01).timeout
	for i in timer.timer_seconds:
		timer_secs = i
		update_text()
		await get_tree().create_timer(0.01).timeout
	for i in timer.timer_minutes:
		timer_mins = i
		update_text()
		await get_tree().create_timer(0.01).timeout
	await get_tree().create_timer(0.5).timeout
	
	var time = int(str(timer_mins) + str(timer_secs) + str(timer_millis))
	if LevelManager.get_level_best_time(LevelManager.currentLevel) >= time:
		LevelManager.set_level_best_time(timer_mins, timer_secs, timer_millis)
		best_time = true
	
	var num_coins: int = LevelManager.get_number_of_coins(LevelManager.currentLevel)
	for i in num_coins:
		coins = i
		update_text()
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(0.5).timeout
	
	for i in player.deathCount:
		deaths = i
		update_text()
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(0.5).timeout
	show_zeros = true
	update_text()

func update_text():
	var time_str: String = "Time: " + str(timer_mins).pad_zeros(2) + ":" + str(timer_secs).pad_zeros(2) + ":" + str(timer_millis).pad_zeros(2)
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
	result_text.text = time_str + coins_str + deaths_str + score_str

func _on_ContinueButton_pressed():
	get_tree().paused = false
	LevelManager.unlock_next_level()
	Global.addCoins(LevelManager.get_number_of_coins(LevelManager.currentLevel))
	SceneTransition.change_scene_to_file("res://scenes/ui/MainMenu.tscn")
