extends Node2D

func _ready():
	if Global.FLOOR_TYPE != Global.floor_types.intro:
		visible = false
		queue_free()
		return
		
	if Global.FLOOR_TYPE == Global.floor_types.intro and !Global.only_supershops:
		visible = false
		queue_free()
		return

func _physics_process(delta):
	z_index = position.y	
