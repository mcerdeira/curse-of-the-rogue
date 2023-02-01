extends Area2D
var taken = false
var particle = preload("res://scenes/particle2.tscn")
export var item_texture : Texture

func _physics_process(delta):
	if taken:
		$sprite.scale.x += 350 * delta
		$sprite.scale.y -= 50 * delta
		$sprite.playing = false
		$sprite.frame = 1
		if $sprite.scale.x > 30:
			queue_free()
			
		if $sprite.scale.y <= 0:
			$sprite.scale.y = 0.1

func _on_Idol_body_entered(body):
	if !taken:
		if body.is_in_group("players"):
			var texture = item_texture
			Global.one_shot_items.append(texture)
			body.add_heart(Global.health.size(), false)
			Global.idol_acquired()
			Global.play_sound(Global.WheelSfx)
			Global.refresh_hud()
			taken = true

func _destroy():
	emit()
	queue_free()

func emit():
	var p = particle.instance()
	get_parent().add_child(p)
	p.global_position = global_position
	p = particle.instance()
	get_parent().add_child(p)
	p.global_position = global_position
