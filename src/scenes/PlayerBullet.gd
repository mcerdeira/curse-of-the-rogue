extends KinematicBody2D
export var type = "knife"
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
var tomahawk_ttl = 0
var falling = false
var _in_water = false

func _ready():
	$Area2D.add_to_group("playerbullet")

func _initialize():
	$sprite.animation = type
	
	if type == "spikeball":
		speed = 0
		dmg = 0.2
	if type == "tomahawk":
		tomahawk_ttl = 0.8
		speed = 150
		dmg = 2
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
		
func in_water():
	if type == "bomb":
		_in_water = true
	
func out_water():
	if type == "bomb":
		_in_water = false
		
func emit():
	var p = particle.instance()
	var root = get_node("/root/Main")
	root.add_child(p)
	p.global_position = global_position
		
func emit_self():
	var p = particle.instance()
	add_child(p)
	p.global_position = global_position

func mini_explode():
	Global.play_sound(Global.BombExplosionSfx)
	var b = Blast.instance()
	var root = get_node("/root/Main")
	root.add_child(b)
	b.global_position = global_position
	b.scale.x = 0.1
	b.scale.y = 0.1
	queue_free()

func explode():
	emit()
	emit()
	emit()
	emit()
	emit()
	emit()
	Global.play_sound(Global.BombExplosionSfx)
	var b = Blast.instance()
	var root = get_node("/root/Main")
	root.add_child(b)
	b.global_position = global_position
	queue_free()
	
func fall():
	Global.play_sound(Global.FallingSfx)
	falling = true
	$sprite.scale.x = 1
	$sprite.scale.y = 1
	
func stop_fall():
	falling = false
	$sprite.scale.x = 0
	$sprite.scale.y = 0
	$sprite.rotation = 0
	mini_explode()

func _physics_process(delta):
	if falling:
		$sprite.rotation += 5 * delta
		$sprite.scale.x -= 2 * delta
		$sprite.scale.y = $sprite.scale.x
		if $sprite.scale.x <= 0:
			stop_fall()
		return
	
	if !init:
		_initialize()
		init = true
	
	z_index = position.y
	
	move_and_slide(speed * dir)
	
	if _in_water and type == "bomb":
		move_and_slide(Vector2(0, Global.water_speed))
	
	if type == "bomb":
		speed -= 1 * delta
		if speed <= 0:
			speed = 0
		
		explode_ttl -= 1 * delta
		if explode_ttl <= 0:
			explode()
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
	elif type == "tomahawk":
		tomahawk_ttl -= 1 * delta
		if tomahawk_ttl <= 0:
			speed = 250
			dir.y = 1 
		
		$sprite.rotation += 15 * delta
	elif type == "spikeball":
		$sprite.rotation += 100 * delta
	elif type == "shot_gun":
		$sprite.rotation += 100 * delta
		
func _on_Area2D_area_entered(area):
	if dmg > 0 and area.is_in_group("enemies"):
		emit()
		area.get_parent().hit(get_parent(), dmg, "player")
		if !piercing:
			if type != "spikeball":
				queue_free()
		else:
			pierce_count -= 1
			if pierce_count <= 0:
				if type != "spikeball":
					queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Walls":
		emit()
		if type != "spikeball" and type != "bomb":
			queue_free()
