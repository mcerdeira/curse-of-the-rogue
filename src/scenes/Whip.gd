extends Area2D
var dmg = 1

func _ready():
	var options = {"pitch_scale": Global.pick_random([0.9, 1, 1.1, 1.2, 1.3])}
	Global.play_sound(Global.WhipSfx, options)
	$sprite.speed_scale = 4
	$sprite.playing = true
	dmg = Global.attack

func _on_sprite_animation_finished():
	queue_free()

func _on_Whip_area_entered(area):
	if area.is_in_group("decorations"):
		area._destroy()
		
	if area.is_in_group("bosses"):
		area.get_parent().hit(get_parent(), dmg, "player") 
	
	if area.is_in_group("enemies"):
		area.get_parent().hit(get_parent(), dmg, "player")
