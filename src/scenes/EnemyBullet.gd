extends KinematicBody2D
var type = ""
var player_chase = null
var player_direction = null
var speed = 0
var dmg = 0
var particle = preload("res://scenes/particle2.tscn")
var dir = Vector2.ZERO

func _ready():
	add_to_group("enemybullets")

func emit():
	var p = particle.instance()
	get_parent().add_child(p)
	p.global_position = global_position
	p = particle.instance()
	get_parent().add_child(p)
	p.global_position = global_position

func _physics_process(delta):
	if type == "bone" or type == "fire_ball":
		if player_chase == null:
			if type == "fire_ball":
				speed = 200
			else:
				speed = 150
			dmg = 1
			player_chase = get_tree().get_nodes_in_group("players")[0]
			player_direction = (player_chase.position - self.position).normalized()
		
		$sprite.animation = type
		if dir != Vector2.ZERO:
			move_and_slide(speed * dir)
			$sprite.rotation = position.angle_to_point(dir)
		else:
			move_and_slide(speed * player_direction)
			if type == "fire_ball":
				$sprite.rotation = position.angle_to_point(player_direction)
			else:
				$sprite.rotation += 10 * delta

func destroy():
	emit()
	queue_free()

func _on_area_body_entered(body):
	if body.name == "Walls":
		destroy()
	if body.is_in_group("players"):
		body.hit(dmg)
		destroy()
