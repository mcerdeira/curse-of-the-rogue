extends Node2D

func _ready():
	add_to_group("waterfalls")
	
func hide_waterfall():
	$spr2.visible = false
	$area/collider2.queue_free()
	$spr1.animation = "short"

func _physics_process(delta):
	z_index = VisualServer.CANVAS_ITEM_Z_MIN + 2

func _on_area_body_entered(body):
	if body.is_in_group("players"):
		if !Global.flying:
			body.in_water()

func _on_area_body_exited(body):
	if body.is_in_group("players"):
		if !Global.flying:
			body.out_water()

func _on_area_area_entered(area):
	if area.is_in_group("decorations"):
		area.destroy_silent()
	
	if area.is_in_group("big_block"):
		if !area.ignore_waterfall:
			area.queue_free()
	
	if area.is_in_group("enemies"):
		if !area.get_parent().flying:
			area.get_parent().in_water()

func _on_area_area_exited(area):
	if area.is_in_group("enemies"):
		if !area.get_parent().flying:
			area.get_parent().out_water()
