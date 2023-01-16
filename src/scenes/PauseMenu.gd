extends Node2D

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("quit_game"):
		if !get_tree().paused:
			Global.normal_cursor()
			get_tree().paused = true
			show()

func _on_Button_pressed():
	Global.custom_cursor()
	get_tree().paused = false
	hide()

func _on_Button2_pressed():
	Global.custom_cursor()
	get_tree().paused = false
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
