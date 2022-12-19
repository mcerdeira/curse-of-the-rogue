extends Node2D
var game_over_visible = 5
var space = "       : "
export var full_hearts : Texture
export var empty_hearts : Texture
export var shield_hearts : Texture
export var shield_poison : Texture
export var shield_zombie : Texture

func _ready():
	add_to_group("HUD")
	$game_over.visible = false
	
func _draw():
	var w = 30
	var acum = 0
	var i = 0
	for h in Global.health:
		acum = 10 + (w * i)
		var tex = null
		if h == 1:
			tex = full_hearts
		elif h == 0:
			tex = empty_hearts
		elif h == 2:
			tex = shield_hearts
		elif h == 3:
			tex = shield_poison
		elif h == 4:
			tex = shield_zombie
		
		draw_texture(tex, to_local(Vector2(acum, 10)))
		i += 1

func update_health():
	update()

func _physics_process(delta):
	if Global.GAME_OVER:
		game_over_visible -= 1 * delta
		if game_over_visible > 0:
			$game_over.visible = true
		else:
			$game_over.visible = false
	else:
		if $game_over.visible:
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
