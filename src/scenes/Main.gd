extends Node2D

func _init():
	Global.init_pool()

func _ready():
	Global.custom_cursor()
	if Global.FLOOR_TYPE == Global.floor_types.intro:
		Global.init_timer()
	else:
		Global.start_timer()
	
	if !Global.Muted:
		music_init()

func music_init():
	if Global.ending_unlocked or Global.FLOOR_TYPE == Global.floor_types.ending or Global.FLOOR_TYPE == Global.floor_types.idols_chamber or Global.FLOOR_TYPE == Global.floor_types.altar or Global.FLOOR_TYPE == Global.floor_types.final_boss or Global.FLOOR_TYPE == Global.floor_types.boss:
		Global.MainThemePlaying = false
		Music.play(Global.ShopAlterTheme, 0.7)
	else:
		if !Global.MainThemePlaying:
			Global.MainThemePlaying = true
			Music.play(Global.MainTheme, 0.7)
