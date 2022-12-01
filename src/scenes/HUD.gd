extends Node2D

func _physics_process(delta):
	$hud_weapon.text = str("WEAPON    :") + Global.primary_wheapon
	$hud_health.text = str("HEALTH    :") + str(Global.health)
	$hud_speed.text =  str("SPEED     :") + str(Global.speed)
	$hud_attack.text = str("ATTCK     :") + str(Global.attack)
	$hud_melee_speed.text = str("ATTCK SPD:") + str(Global.attack_rate)
