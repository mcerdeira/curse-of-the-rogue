extends Area2D
var player_in = false
var player = null
var dmg = 1

func _ready():
	z_index = VisualServer.CANVAS_ITEM_Z_MIN

func _physics_process(delta):
	if player_in:
		if $sprite.frame == 1:
			player.hit(dmg)

func _on_Spikes_body_entered(body):
	if body.is_in_group("players"):
		if !Global.flying:
			player_in = true
			player = body

func _on_Spikes_body_exited(body):
	if body.is_in_group("players"):
		if !Global.flying:
			player_in = false
			player = null

func _on_Spikes_area_entered(area):
	if area.is_in_group("waterfalls"):
		queue_free()
	
	if area.is_in_group("big_block"):
		queue_free()
	
	if area.is_in_group("enemies"):
		if !area.get_parent().flying:
			if $sprite.frame == 1:
				area.get_parent().hit(null, dmg, "megaray")
