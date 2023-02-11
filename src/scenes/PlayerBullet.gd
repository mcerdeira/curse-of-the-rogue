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
var ttl = 3.3

func _ready():
	$Area2D.add_to_group("playerbullet")

func _initialize():
	$sprite.animation = type
	$sprite2.animation = type
	if type != "power_glove":
		$Area2D/collider2.queue_free()
	
	if type == "power_glove":
		$Area2D/collider2.set_deferred("disabled", false)
		$Area2D/collider.queue_free()
		$sprite.visible = false
		$sprite2.visible = true
		$sprite2.playing = true
		speed = 0
		dmg = 0.1
	if type == "spells_book":
		$sprite.playing = true
		speed = 350
		dmg = 1.5
	if type == "spikeball":
		speed = 0
		dmg = 0.2
	if type == "tomahawk":
		tomahawk_ttl = 0.8
		speed = 150
		dmg = 2
	if type == "grandpa_photo":
		$sprite.playing = true
		speed = 350
		dmg = 0.4
	if type == "plasma":
		$sprite.playing = true
		speed = 350
		dmg = 1.5
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
		speed = 450
		
func in_water():
	if type == "bomb":
		_in_water = true
	
func out_water():
	if type == "bomb":
		_in_water = false
		
func emit(where:=null):
	var p = particle.instance()
	var root = get_node("/root/Main")
	root.add_child(p)
	if where == null:
		p.global_position = global_position
	else:
		p.global_position = where
		
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
	
	if speed != 0:
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
			
	elif type == "grandpa_photo":
		if !dir:
			var _chase = get_tree().get_nodes_in_group("enemies")
			if _chase.size() > 0:
				randomize()
				_chase.shuffle()
				dir = (_chase[0].global_position - self.global_position).normalized()
				$sprite.look_at(_chase[0].global_position)
			else:
				queue_free()
		
	elif type == "knife":
		if !dir:
			var _chase = get_tree().get_nodes_in_group("enemies")
			if _chase.size() > 0:
				randomize()
				_chase.shuffle()
				dir = (_chase[0].global_position - self.global_position).normalized()
				$sprite.look_at(_chase[0].global_position)
			else:
				queue_free()
		
	elif type == "plasma" or type == "spells_book":
		$sprite.look_at(to_global(dir))
		
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
	elif type == "power_glove":
		ttl -= 1 * delta
		Global.shaker_obj.shake(Global.pick_random([2, 3, 4]), 0.2)
		var mouse_pos = get_global_mouse_position()
		var angle = get_angle_to(mouse_pos)
		$sprite2.rotation = angle
		$Area2D.rotation = angle
		$Area2D.scale.x = randi() % 2
		dmg = Global.pick_random([0.1, 0.2, 0.3, 0.5, 1])
		if get_parent().entering:
			ttl = -1
		
		if ttl <= 0:
			var parent = get_parent()
			parent.bulletonetimecreated[parent.bulletonetimecreated_glove] = false
			queue_free()
		
func _on_Area2D_area_entered(area):
	var go_emit = false
	if area.is_in_group("decorations"):
		go_emit = true
		area._destroy()
		
	if dmg > 0 and area.is_in_group("bosses"):
		go_emit = true
		area.get_parent().hit(get_parent(), 0.1, "player")
		if !piercing:
			if type != "spikeball" and type != "power_glove":
				queue_free()
		else:
			pierce_count -= 1
			if pierce_count <= 0:
				if type != "spikeball":
					queue_free()
	
	if dmg > 0 and area.is_in_group("enemies"):
		go_emit = true
		area.get_parent().hit(get_parent(), dmg, "player")
		if !piercing:
			if type != "spikeball" and type != "power_glove":
				queue_free()
		else:
			pierce_count -= 1
			if pierce_count <= 0:
				if type != "spikeball":
					queue_free()
					
	if go_emit:
		if type != "power_glove":
			emit()

func _on_Area2D_body_entered(body):
	if body.name == "Walls":
		if type != "power_glove":
			emit()
		if type != "spikeball" and type != "bomb" and type != "power_glove":
			queue_free()
