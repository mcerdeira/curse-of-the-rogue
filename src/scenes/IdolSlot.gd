extends Area2D

func activate_idol(perk):
	$lbl_perk.text = trad_perk(perk)
	$sprite_idol.visible = true
	$FireParticles.visible = true

func trad_perk(perk):
	if perk == "dmg":
		return "Damage"
	elif perk == "life":
		return "Life"
	elif perk == "speed":
		return "Speed"
	elif perk == "melee_speed":
		return "Melee"
	elif perk == "shoot_speed":
		return "Shoot"
