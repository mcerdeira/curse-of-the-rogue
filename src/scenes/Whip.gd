extends Area2D
var hit = false
var dmg = 1

func _ready():
	Global.play_sound(Global.WhipSfx)
	$sprite.speed_scale = 4
	$sprite.playing = true
	dmg = Global.attack

func _on_sprite_animation_finished():
	queue_free()

func _on_Whip_area_entered(area):
	if area.is_in_group("decorations"):
		area._destroy()
	
	if !hit and area.is_in_group("enemies"):
		hit = true
		area.get_parent().hit(get_parent(), dmg, "player")
