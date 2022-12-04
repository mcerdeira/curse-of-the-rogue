extends Node2D

var space = "       : "

func _ready():
	$game_over.visible = false

func _physics_process(delta):
	if Global.GAME_OVER:
		$game_over.visible = true
	
	$hud_weapon.text = str(space) + Global.primary_wheapon
	$hud_health.text = str(space) + str(Global.health)
	$hud_speed.text =  str(space) + str(Global.speed)
	$hud_attack.text = str(space) + str(Global.attack)
	$hud_melee_speed.text = str(space) + str(Global.attack_rate)
