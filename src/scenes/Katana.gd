extends Area2D
var hit = false
var dmg = 1.5
var player = null

func _ready():
	var options = {"pitch_scale": Global.pick_random([0.9, 1, 1.1, 1.2, 1.3])}
	Global.play_sound(Global.KatanaSfx, options)
	dmg = Global.attack

func _physics_process(delta):
	player = get_parent()
	if player.back:
		z_index = -1
	else:
		z_index = 1
	
	rotation_degrees += (900 * -scale.x) * delta
	if abs(rotation_degrees) >= 360:
		queue_free()

func _on_Katana_area_entered(area):
	if area.is_in_group("decorations"):
		area._destroy()
	
	if !hit and area.is_in_group("enemies"):
		hit = true
		area.get_parent().hit(get_parent(), dmg, "player")
