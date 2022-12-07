extends Area2D
var gem_count = 1
var particle = preload("res://scenes/particle2.tscn")

func _ready():
	add_to_group("collectables")

func _on_Gem_body_entered(body):
	if body.is_in_group("players"):
		body.add_gem(gem_count)
		queue_free()

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
