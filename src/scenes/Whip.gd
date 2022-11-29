extends Area2D

func _ready():
	$sprite.speed_scale = 4
	$sprite.playing = true

func _on_sprite_animation_finished():
	queue_free()

func _on_Whip_area_entered(area):
	if area.is_in_group("enemies"):
		area.get_parent().hit()
