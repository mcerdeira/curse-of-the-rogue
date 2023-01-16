extends Node2D
var game_over_visible = 2.7

func _ready():
	hide()

func _physics_process(delta):
	if Global.GAME_OVER:
		game_over_visible -= 1 * delta
		if !visible and game_over_visible <= 0:
			Global.normal_cursor()
			show()

func _on_Button_pressed():
	Global.custom_cursor()
	Global.restart_game()

func _on_Button2_pressed():
	Global.custom_cursor()
	get_tree().paused = false
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
