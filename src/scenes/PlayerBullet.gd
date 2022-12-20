extends KinematicBody2D
var type = "knife"
var explode_ttl = 2
var dir = Vector2.ZERO
var Blast = preload("res://scenes/Blast.tscn")
var particle = preload("res://scenes/particle2.tscn")
var speed = 0
var init = false
var target = null
var dmg = 0
var piercing = false
var pierce_count = 0

func _initialize():
	$sprite.animation = type
	
	if type == "plasma":
		speed = 150
		dmg = 1
	if type == "bomb":
		speed = 10
		dmg = 0
	if type == "knife":
		piercing = true
		pierce_count = 2
		dmg = 1
		speed = 500
	if type == "shot_gun":
		for i in range(4):
			emit_self()
		dmg = 2
		speed = 250
		
func emit():
	var p = particle.instance()
	var root = get_node("/root/Main")
	root.add_child(p)
	p.global_position = global_position
		
func emit_self():
	var p = particle.instance()
	add_child(p)
	p.global_position = global_position

func explode():
	emit()
	emit()
	emit()
	var b = Blast.instance()
	var root = get_node("/root/Main")
	root.add_child(b)
	b.global_position = global_position

func _physics_process(delta):
	if !init:
		_initialize()
		init = true
	
	z_index = position.y
	
	move_and_slide(speed * dir)
	
	if type == "bomb":
		speed -= 1 * delta
		if speed <= 0:
			speed = 0
		
		explode_ttl -= 1 * delta
		if explode_ttl <= 0:
			explode()
			queue_free()
		if explode_ttl <= 1:
			$sprite.playing = true
			$sprite.speed_scale = 2
		
	elif type == "knife":		
		if !dir:
			var _chase = get_tree().get_nodes_in_group("enemies")
			if _chase.size() > 0:
				randomize()
				_chase.shuffle()
				dir = (_chase[0].global_position - self.global_position).normalized()
				$sprite.look_at(_chase[0].global_position)
		
	elif type == "plasma":
		$sprite.rotation = position.angle_to_point(dir)
	elif type == "shot_gun":
		$sprite.rotation += 100 * delta
		
func _on_Area2D_area_entered(area):
	if dmg > 0 and area.is_in_group("enemies"):
		emit()
		area.get_parent().hit(get_parent(), dmg, "player")
		if !piercing:
			queue_free()
		else:
			pierce_count -= 1
			if pierce_count <= 0:
				queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Walls":
		emit()
		queue_free()
