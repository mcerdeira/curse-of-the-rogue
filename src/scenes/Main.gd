extends Node2D

func _init():
	Global.init_pool()

func _ready():	
	if Global.FLOOR_TYPE == Global.floor_types.intro:
		Global.init_timer()
	else:
		Global.start_timer()
	
	if !Global.Muted:
		music_init()
	
	if Global.FLOOR_TYPE != Global.floor_types.altar:
		$Colums.queue_free()

func music_init():
	if Global.FLOOR_TYPE == Global.floor_types.altar or Global.FLOOR_TYPE == Global.floor_types.boss:
		Global.MainThemePlaying = false
		Music.play(Global.ShopAlterTheme, 0.7)
	else:
		if !Global.MainThemePlaying:
			Global.MainThemePlaying = true
			Music.play(Global.MainTheme, 0.7)
