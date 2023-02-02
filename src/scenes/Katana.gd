extends Area2D
var dmg = 1
var player = null
var finish = false
var die_ttl = 0.1

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
	if finish:
		die_ttl -= 1 * delta
		if die_ttl <= 0:
			queue_free()
	else:
		rotation_degrees += (2000 * -scale.x) * delta
		if abs(rotation_degrees) >= 360:
			finish = true

func _on_Katana_area_entered(area):
	if area.is_in_group("decorations"):
		area._destroy()
		
	if area.is_in_group("bosses"):
		area.get_parent().hit(get_parent(), dmg, "player") 
	
	if area.is_in_group("enemies"):
		area.get_parent().hit(get_parent(), dmg, "player")
