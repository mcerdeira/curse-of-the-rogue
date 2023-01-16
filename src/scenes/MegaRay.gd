extends KinematicBody2D
var on = true
var shoot_delay = 0
var shoot_delay_total = 0
var dmg = 3
var shooting = 0
var shooting_total = 3

func area_on(val):
	$particle.visible = val
	$particle2.visible = val
	$particle3.visible = val
	$particle4.visible = val

	$area.visible = val
	$area/collider.set_deferred("disabled", !val)

func _ready():
	z_index = VisualServer.CANVAS_ITEM_Z_MIN + 1
	shoot_delay_total = 8
	shoot_delay = shoot_delay_total
	if Global.FLOOR_TYPE != Global.floor_types.normal or !Global.pick_random([false, false, true]):
		queue_free()
		return
	else:
		area_on(false)
		
func turn_off():
	$sprite.speed_scale = 0.5
	$sprite2.speed_scale = 0.5
	$sprite.playing = false
	$sprite.frame = 0
	$sprite2.playing = false
	$sprite2.frame = 0
	area_on(false)

func _physics_process(delta):
	if Global.FLOOR_OVER:
		if on:
			on = false
			turn_off()
	else:
		if shooting <= 0:
			shoot_delay -= 1 * delta
			if shoot_delay <= shoot_delay_total / 2:
				$sprite.speed_scale += 1 * delta
				$sprite2.speed_scale += 1 * delta
				$sprite.playing = true
				$sprite2.playing = true
			
			if shoot_delay <= 0:
				shoot_delay = shoot_delay_total
				shoot()
		else:
			shooting -= 1 * delta
			if shooting <= 0:
				turn_off()

func shoot():
	Global.play_sound(Global.MegaRaySfx)
	area_on(true)
	shooting = shooting_total

func _on_area_body_entered(body):
	if shooting > 0:
		if body.is_in_group("players"):
			if !Global.flying:
				body.hit(dmg, "megaray")

func _on_area_area_entered(area):
	if area.is_in_group("decorations"):
		area._destroy()
	
	if area.is_in_group("collectables"):
		area._destroy()
		
	if area.is_in_group("enemies"):
		if !area.get_parent().flying and !area.get_parent().fireinmune:
			area.get_parent().hit(null, dmg, "lava_stream")
