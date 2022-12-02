extends Node2D

var space = "       : "

func _physics_process(delta):
	$hud_weapon.text = str(space) + Global.primary_wheapon
	$hud_health.text = str(space) + str(Global.health)
	$hud_speed.text =  str(space) + str(Global.speed)
	$hud_attack.text = str(space) + str(Global.attack)
	$hud_melee_speed.text = str(space) + str(Global.attack_rate)
