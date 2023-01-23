extends KinematicBody2D

var speed = 0
var player_chase = null
var enemy_list = null
var ready = false
var stop_moving = 0
var die_ttl = 0.1
var rot_speed = 1

func _ready():
	rot_speed = Global.pick_random([1, 3])
	player_chase = get_tree().get_nodes_in_group("players")[0]
	speed = 50
	enemy_list = get_children()
	find_player()

func _physics_process(delta):
	if !ready:
		ready = true
		for e in enemy_list:
			if e.iamasign:
				ready = false
				break
	else:
		if Global.GAME_OVER:
			return
	
		rotation += rot_speed * delta
		
		var alive = false
		for e in enemy_list:
			if is_instance_valid(e):
				e.rotation = -rotation
				alive = true
		
		if !alive:
			die_ttl -= 1 * delta
			if die_ttl <= 0:
				queue_free()
		
		if stop_moving > 0:
			stop_moving -= 1 * delta
	
		var direction = (player_chase.position - self.position).normalized()
		if player_chase.position.distance_to(position) <= 2:
			stop_moving = 1
			
		if stop_moving <= 0:
			move_and_slide(speed * direction)
			
func find_player():
	player_chase = get_tree().get_nodes_in_group("players")[0]
