extends Area2D
var gem_count = 1

func _on_Gem_body_entered(body):
	if body.is_in_group("players"):
		body.add_gem(gem_count)
		queue_free()
