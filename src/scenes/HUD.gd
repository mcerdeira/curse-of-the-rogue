extends Node2D
var game_over_visible = 5
var space = "       : "

func _ready():
	$game_over.visible = false

func _physics_process(delta):
	if Global.GAME_OVER:
		game_over_visible -= 1 * delta
		if game_over_visible > 0:
			$game_over.visible = true
		else:
			$game_over.visible = false

	if Global.combo_time > 0:
		Global.combo_time -= 1 * delta
		if Global.combo_time <= 0:
			Global.combo_time = 0
			Global.current_combo = 0

	if Global.current_combo > 0:
		$combo.text = "x " + str(Global.current_combo)
	else:
		$combo.text = ""
		
	$hud_weapon.text = str(space) + Global.primary_wheapon
	$hud_health.text = str(space) + str(Global.health)
	$hud_speed.text =  str(space) + str(Global.speed)
	$hud_attack.text = str(space) + str(Global.attack)
	$hud_melee_speed.text = str(space) + str(Global.attack_rate)
