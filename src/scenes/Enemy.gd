extends KinematicBody2D
var life = 0
var dmg = 1
var iamasign_ttl = 0.9
var iamasign = true
var speed = 0
var player_chase = null
var particle = preload("res://scenes/particle2.tscn")
var dead = false
var impulse = null
var hit_ttl = 0
var hit_ttl_total = 0.2

func _ready():
	$shadow.visible = false
	$sprite.animation = "sign"
	$area.add_to_group("enemies")

func emit():
	var p = particle.instance()
	get_parent().add_child(p)
	p.set_position(to_global(p.position))
	p = particle.instance()
	get_parent().add_child(p)
	p.set_position(to_global(p.position))

func _physics_process(delta):
	if !iamasign:
		enemy_behaviour(delta)
	else:
		if iamasign_ttl > 0:
			iamasign_ttl -= 1 * delta
		if iamasign_ttl <= 0:
			$shadow.visible = true
			emit()
			find_player()
			set_type()
			iamasign = false
			
func find_player():
	player_chase = get_tree().get_nodes_in_group("players")[0]
			
func enemy_behaviour(delta):
	face_player()
	if hit_ttl > 0:
		$sprite.playing = false
		hit_ttl -= 1 * delta
		if hit_ttl <= 0:
			hit_ttl = 0
			$sprite.playing = true
			impulse = null
	
	if !dead and hit_ttl <= 0:
		if !player_chase.dead:
			var player_direction = (player_chase.position - self.position).normalized()
			move_and_slide(speed * player_direction)
		else:
			$sprite.playing = false
	
	if impulse:
		move_and_slide((-speed*5) * impulse)
	
	if dead and hit_ttl <= 0:
		die()
	
func face_player():
	if position.x > player_chase.position.x:
		$sprite.scale.x = 1
	else:
		$sprite.scale.x = -1
	
func set_type():
	$sprite.animation = "scorpion"
	speed = 100
	life = 1
	
func hit(origin, dmg:= 1):
	if !iamasign:
		life -= dmg
		hit_ttl = hit_ttl_total
		impulse = (origin.position - self.position).normalized()
		if life <= 0:
			dead = true

func die():
	if !iamasign:
		emit()
		queue_free()

func _on_area_body_entered(body):
	if body.is_in_group("players"):
		body.hit(dmg, self)
