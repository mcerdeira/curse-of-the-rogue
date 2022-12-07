extends Area2D
var gem_count = 1
var particle = preload("res://scenes/particle2.tscn")
var taken = false

func _ready():
	add_to_group("collectables")
	
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
			
func _on_Gem_body_entered(body):
	if !taken:
		if body.is_in_group("players"):
			taken = true
			body.add_gem(gem_count)

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
