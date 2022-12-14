extends Node2D
var game_over_visible = 5
var space = "       : "
var message_ttl = 0
var combo_text = "  COMBO: "
var game_over_text = "YOU DIED"
export var full_hearts : Texture
export var empty_hearts : Texture
export var shield_hearts : Texture
export var shield_poison : Texture
export var shield_zombie : Texture

func _ready():
	add_to_group("HUD")
	$c/game_over.visible = false
	
func _draw():
	var w = 30
	var acum = $MiniHUDPos.position
	var i = 0
	var count = 0
	
	for itm in Global.one_shot_items:
		count += 1
		draw_texture(itm, to_local(Vector2(acum.x, acum.y)))
		acum.x += 32
		if count == 4:
			count = 0
			acum.x = $MiniHUDPos.position.x
			acum.y += 32
	
	w = 30
	acum = 0
	i = 0
	
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
	
func set_message(title, msg):
	message_ttl = 1.5
	$c/game_over.visible = true
	$c/game_over.text = title
	$c/subtitle.text = "\n\n\n\n" + msg
	
func _physics_process(delta):
	if !Global.GAME_OVER and message_ttl > 0:
		message_ttl -= 1 * delta
		if message_ttl <= 0:
			message_ttl = 0
			$c/subtitle.text = ""
			$c/game_over.text = game_over_text
			$c/game_over.visible = false
	
	if Global.GAME_OVER:
		$c/subtitle.text = ""
		$c/game_over.text = game_over_text
		game_over_visible -= 1 * delta
		if game_over_visible > 0:
			$c/game_over.visible = true
		else:
			$c/game_over.visible = false
	else:
		if $c/game_over.visible and message_ttl <= 0:
			$c/subtitle.text = ""
			$c/game_over.visible = false

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
	$automatic_weapon.animation = Global.automatic_weapon
	
	$hud_speed.text =  str(space) + str(Global.speed/100.00)
	$hud_attack.text = str(space) + str(Global.attack)
	$hud_melee_speed.text = str(space) + str(Global.melee_rate_total)
	$hud_shoot_speed.text = str(space) + str(Global.shoot_speed_total)
	$hud_combo_count.text = combo_text + str(Global.max_combo)
	$hud_luck.text = str(space) + str(Global.total_bad_luck - Global.bad_luck) + "%"
	$hud_keys.text = str(space) + str(Global.keys)
