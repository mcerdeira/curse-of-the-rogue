extends Node2D
var current_timer = 0.5
var first_time = true
var ItemPedestal = preload("res://scenes/ItemPedestal.tscn")
var enemy = preload("res://scenes/Enemy.tscn")
var bat_group = preload("res://scenes/EnemyGroup.tscn")
var chest = preload("res://scenes/Chest.tscn")
var plant = preload("res://scenes/Plants.tscn")
var min_count = 3
var WAVE_COUNT = 0
var plants_created = false

func create_plants():
	var count = Global.pick_random([1, 3, 5, 7, 0])
	var positions = get_children()
	var pinst = null
	for i in range(count):
		positions.shuffle()
		var p = positions.pop_front()
		pinst = plant.instance()
		get_parent().add_child(pinst)
		pinst.global_position = p.global_position

func _physics_process(delta):
	if !plants_created:
		plants_created = true
		create_plants()
	
	if Global.FLOOR_TYPE == Global.floor_types.normal:
		if !Global.GAME_OVER and !Global.FLOOR_OVER:
			current_timer -= 1 * delta
			if !first_time:
				if current_timer > 1:
					if get_tree().get_nodes_in_group("enemies").size() == 0:
						current_timer = 1
			
			if current_timer <= 0:
				first_time = false
				current_timer = Global.reset_spawn_timer()
				spawn_enemy()
	else:
		if first_time:
			reveal_doors()
			first_time = false
			
func get_random_point():
	randomize()
	var positions = get_children()
	positions.shuffle()
	var p = positions.pop_front()
	return p
	
func reveal_doors():
	var doors = get_tree().get_nodes_in_group("doors")
	for d in doors:
		d.reveal()
	
func spawn_chest_and_stuff():
	reveal_doors()
	
	var do_chest = true
	var buff = 64
	randomize()
	var posibility = randi() % 10
	if (posibility) == 0:
		buff = 96
		do_chest = false
	
	var player = get_tree().get_nodes_in_group("players")[0]
	var positions = get_children()
	var last_pos = 999999999
	var obj_pos = null
	for pos in positions:
		var p = pos.position.distance_to(player.position)
		if last_pos > p and p > buff:
			last_pos = p
			obj_pos = pos.position
	
	var obj_inst = null

	if do_chest:
		obj_inst = chest.instance()
	else:
		obj_inst = ItemPedestal.instance()
	
	get_parent().add_child(obj_inst)
	obj_inst.set_position(to_global(obj_pos))
		
func spawn_enemy():
	if WAVE_COUNT < Global.get_floor_waves():
		WAVE_COUNT += 1
		var positions = get_children()
		
		var enemies = Global.enemy_by_floor()
		
		for i in range(enemies.size()):
			positions.shuffle()
			var p = positions.pop_front()
			var type  = enemies[i]
			var enemy_inst = null

			if type == "bat":
				enemy_inst = bat_group.instance()
			else:
				enemy_inst = enemy.instance()
				enemy_inst.enemy_type = type
				
			get_parent().add_child(enemy_inst)
			enemy_inst.global_position = p.global_position
			enemy_inst.spawner = self
	else:
		if !Global.FLOOR_OVER and get_tree().get_nodes_in_group("enemies").size() == 0:
			Global.FLOOR_OVER = true
			spawn_chest_and_stuff()
