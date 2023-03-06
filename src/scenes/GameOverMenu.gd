extends Node2D
var game_over_visible = 2.7

func _ready():
	hide()

func _physics_process(delta):
	if Global.GAME_OVER:
		game_over_visible -= 1 * delta
		if !visible and game_over_visible <= 0:
			Global.normal_cursor()
			display_time()
			display_killer()
			display_kills()
			show()
			
func format_description(text):
	var tmp = text
	tmp = tmp.replace("_", " ").replace("+", "").capitalize()
	return tmp

func display_kills():
	$Label5.text = "Kills:\n"
	$Label5.text += str(Global.kills) 

func display_killer():
	if Global.KillerisMe == "chest_closed":
		Global.KillerisMe = "mimic"
	
	$KillU.animation = Global.KillerisMe
	var description = format_description(Global.KillerisMe)
	
	if Global.KillerisMeExtra != "":
		$KillUExtra.animation = Global.KillerisMeExtra
		description = Global.CURRENT_BOSS_NAME
	else:
		$KillUExtra.animation = "none"
	
	$Label4.text = description

func display_time():
	$Label3.text = "Duration:\n"
	$Label3.text += HFormat(Global.Hours) + ":" + HFormat(Global.Minutes) + ":" + HFormat(Global.Seconds)

func HFormat(v):
	var tmp = str(int(v))
	if tmp.length() == 1:
		tmp = "0" + tmp
	return tmp

func _on_Button_pressed():
	Global.custom_cursor()
	Global.restart_game()

func _on_Button2_pressed():
	Global.custom_cursor()
	get_tree().paused = false
	Global.boot_strap_game()
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
