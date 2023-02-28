extends Node2D
var text = ""
var ttl = 3
var shake = false

func _physics_process(delta):
	if shake:
		rotation_degrees = randi() % 2 * Global.pick_random([1, -1])
	
	if $lbl.text == "":
		$lbl.text = text
	else:
		ttl -= 1 * delta
		if ttl <= 0:
			queue_free()
