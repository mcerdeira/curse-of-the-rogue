extends Node2D

func _ready():
	Global.init_pool()
	
	if !Global.Muted:
		music_init()
	
	if Global.FLOOR_TYPE != Global.floor_types.altar:
		$Colums.queue_free()

func music_init():
	if Global.FLOOR_TYPE == Global.floor_types.altar:
		Global.MainThemePlaying = false
		Music.play(Global.ShopAlterTheme, 0.7)
	else:
		if !Global.MainThemePlaying:
			Global.MainThemePlaying = true
			Music.play(Global.MainTheme, 0.7)
