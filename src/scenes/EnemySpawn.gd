extends Node2D
var current_timer = 0.5
var first_time = true
var enemy = preload("res://scenes/Enemy.tscn")
var min_count = 3

func _physics_process(delta):
	if !Global.GAME_OVER:
		current_timer -= 1 * delta
		if !first_time:
			if current_timer > 1:
				if get_tree().get_nodes_in_group("enemies").size() == 0:
					current_timer = 1
		
		if current_timer <= 0:
			first_time = false
			current_timer = Global.reset_spawn_timer()
			spawn_enemy()
			
func get_random_point():
	randomize()
	var positions = get_children()
	positions.shuffle()
	var p = positions.pop_front()
	return p
		
func spawn_enemy():
	var positions = get_children()
	var count = min_count + floor(Global.CURRENT_FLOOR * 1.5)
	for i in range(count):
		randomize()
		positions.shuffle()
		var p = positions.pop_front()
		
		var enemy_inst = enemy.instance()
		get_parent().add_child(enemy_inst)
		enemy_inst.set_position(to_global(p.position))
		enemy_inst.spawner = self
