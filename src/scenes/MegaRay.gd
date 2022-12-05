extends KinematicBody2D
var shoot_delay = 0
var shoot_delay_total = 0
var dmg = 3
var shooting = 0
var shooting_total = 3

func area_on(val):
	$area.visible = val
	$area/collider.set_deferred("disabled", !val)

func _ready():
	if !Global.pick_random([false, false, true]):
		queue_free()
	else:
		shoot_delay_total = Global.pick_random([5, 8, 10])
		shoot_delay = shoot_delay_total
		area_on(false)

func _physics_process(delta):
	if shooting <= 0:
		shoot_delay -= 1 * delta
		if shoot_delay <= 0:
			shoot_delay = shoot_delay_total
			shoot()
	else:
		shooting -= 1 * delta
		if shooting <= 0:
			area_on(false)

func shoot():
	area_on(true)
	shooting = shooting_total

func _on_area_body_entered(body):
	if shooting > 0:
		if body.is_in_group("players"):
			body.hit(dmg, self)

func _on_area_area_entered(area):
	if area.is_in_group("enemies"):
		area.get_parent().hit(get_parent(), dmg)
