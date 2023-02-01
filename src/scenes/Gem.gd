extends Area2D
var gem_count = 1
var particle = preload("res://scenes/particle2.tscn")
var taken = false
var player = null
var speed = 150
var go_back_ttl = 0.1
var absorved = false
var type = "gem"
var dist = 60

func _ready():
	add_to_group("collectables")
	player = get_tree().get_nodes_in_group("players")[0]
	if Global.magnet:
		dist *= 2

func _init_sprite():
	$sprite.animation = type

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
	else:
		if !Global.GAME_OVER and !Global.LOGIC_PAUSE:
			if !absorved and position.distance_to(player.position) <= dist:
				absorved = true
			elif absorved:
				if go_back_ttl > 0:
					go_back_ttl -= 1 * delta
					position = position.move_toward(player.position, delta * (speed * -1))
				else:
					position = position.move_toward(player.position, delta * speed)
					speed += 1000 * delta
			
func _on_Gem_body_entered(body):
	if !taken:
		if body.is_in_group("players"):
			taken = true
			if type == "gem":
				body.add_gem(gem_count)
			elif type == "key":
				body.add_key(gem_count)
			elif type == "life":
				body.add_heart(gem_count)

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
