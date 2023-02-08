extends Node2D

func _ready():
	hide()
	
func _physics_process(delta):
	if Global.GAME_OVER and visible:
		hide()

func _input(event):
	if !Global.GAME_OVER and !Global.transition_obj.visible:
		if event.is_action_pressed("quit_game"):
			if !get_tree().paused:
				Global.normal_cursor()
				get_tree().paused = true
				show()
			else:
				Global.custom_cursor()
				get_tree().paused = false
				hide()

func _on_Button_pressed():
	Global.custom_cursor()
	get_tree().paused = false
	hide()

func _on_Button2_pressed():
	Global.save_game()
	Global.custom_cursor()
	get_tree().paused = false
	Global.boot_strap_game()
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
