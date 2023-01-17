extends Area2D
var dmg = 2.5

func _ready():
	Global.shaker_obj.shake(3, 0.2)
	z_index = VisualServer.CANVAS_ITEM_Z_MAX

func _on_sprite_animation_finished():
	queue_free()

func _on_Blast_body_entered(body):
	if body.is_in_group("players"):
		body.hit(dmg, "blast")

func _on_Blast_area_entered(area):
	if area.is_in_group("decorations"):
		area._destroy()
	
	if area.is_in_group("enemies"):
		area.get_parent().hit(get_parent(), dmg, "blast")
