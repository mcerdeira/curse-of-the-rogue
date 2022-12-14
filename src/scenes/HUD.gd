extends Node2D
var game_over_visible = 5
var space = "       : "
export var full_hearts : Texture
export var empty_hearts : Texture
export var shield_hearts : Texture

func _ready():
	add_to_group("HUD")
	$game_over.visible = false
	
func _draw():
	var w = 30
	var acum = 0
	for i in range(Global.health_total + Global.shield):
		acum = 10 + (w * i)
		if i < Global.health_total:
			if Global.health > i:
				draw_texture(full_hearts, to_local(Vector2(acum, 10)))
			else:
				draw_texture(empty_hearts, to_local(Vector2(acum, 10)))
		else:
			draw_texture(shield_hearts, to_local(Vector2(acum, 10)))
			
func update_health():
	update()

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
	
	$hud_gems.text = str(space) + str(Global.gems)
	$primary_weapon.animation = Global.primary_weapon
	$secondary_weapon.animation = Global.secondary_weapon
	$hud_speed.text =  str(space) + str(Global.speed)
	$hud_attack.text = str(space) + str(Global.attack)
	$hud_melee_speed.text = str(space) + str(Global.melee_rate_total)
	$hud_combo_count.text = "  COMBO: " + str(Global.max_combo)
	$hud_luck.text = str(space) + str(Global.total_bad_luck - Global.bad_luck) + "%"
	$hud_keys.text = str(space) + str(Global.keys)
