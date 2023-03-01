extends Node2D
var text = ""
var ttl = 3
var goup_ttl = 0.5
var shake = false
var color_override = null
var goup = false
var disappear = false

func _physics_process(delta):
	if shake:
		rotation_degrees = randi() % 2 * Global.pick_random([1, -1])
		
	if goup and goup_ttl > 0:
		goup_ttl -= 1 * delta
		position.y -= 120 * delta
	
	if $lbl.text == "":
		$lbl.text = text
		if color_override != null:
			$lbl.add_color_override("font_color", color_override)
	else:
		if disappear and goup_ttl <= 0:
			$lbl.modulate.a = lerp($lbl.modulate.a, 0, 0.1)
		
		ttl -= 1 * delta
		if ttl <= 0:
			queue_free()
