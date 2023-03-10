extends Node2D
var started = false
var player = null

func _ready():
	if Global.FLOOR_TYPE != Global.floor_types.altar and Global.FLOOR_TYPE != Global.floor_types.shop and Global.FLOOR_TYPE != Global.floor_types.supershop:
		queue_free()
		return
	else:
		if randi() % 2 == 0:
			queue_free()
			return

func burn():
	started = true
	$FireParticles.visible = true
	
func burn_off():
	started = false
	$FireParticles.visible = false
	
func _on_BonFire_body_entered(body):
	if !started and body.is_in_group("players"):
		started = true
		Global.BonFireDialog.start(body, self)
