extends Node2D
var current_timer = 0.5
var first_time = true
var ItemPedestal = preload("res://scenes/ItemPedestal.tscn")
var enemy = preload("res://scenes/Enemy.tscn")
var bat_group = preload("res://scenes/EnemyGroup.tscn")
var chest = preload("res://scenes/Chest.tscn")
var plant = preload("res://scenes/Plants.tscn")
var mimic = preload("res://scenes/Enemy.tscn")
var idol = preload("res://scenes/Idol.tscn")
var min_count = 3
var WAVE_COUNT = 0
var plants_created = false

func _ready():
	Global.SPAWNER = self

func create_plants():
	var vegetation = false
	var count = 0
	var positions = get_children()
	vegetation = (randi() % 50 == 0)
	
	if vegetation:
		count = positions.size() - 2
	else:
		count = Global.pick_random([1, 3, 5, 7, 0])
		
	var pinst = null
	for i in range(count):
		positions.shuffle()
		var p = positions.pop_front()
		pinst = plant.instance()
		pinst.vegetation = vegetation
		get_parent().add_child(pinst)
		pinst.global_position = p.global_position

func _physics_process(delta):
	if Global.FLOOR_TYPE != Global.floor_types.intro and Global.FLOOR_TYPE  != Global.floor_types.idols_chamber:       
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
	elif Global.FLOOR_TYPE == Global.floor_types.boss:
		if get_tree().get_nodes_in_group("enemy_objects").size() == 0:
			if !Global.GAME_OVER and !Global.FLOOR_OVER:
				Global.FLOOR_OVER = true
				spawn_chest_and_stuff(false, true)
	else:
		if first_time:
			if Global.FLOOR_TYPE == Global.floor_types.altar:
				spawn_chest_and_stuff(true)
			
			if Global.FLOOR_TYPE == Global.floor_types.intro:
				if randi() % 10 == 0:
					spawn_chest_and_stuff(true)
			
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
		
	Global.play_sound(Global.LevelEndSfx)
	
func find_farthest_to_chest(chest, buff):
	var positions = get_children()
	var last_pos = 0
	var obj_pos = null
	for pos in positions:
		var p = pos.position.distance_to(chest.position)
		if last_pos < p:
			last_pos = p
			obj_pos = pos.position
	
	return obj_pos
	
func find_closest_player(buff):
	var player = get_tree().get_nodes_in_group("players")[0]
	var positions = get_children()
	var last_pos = 999999999
	var obj_pos = null
	for pos in positions:
		var p = pos.position.distance_to(player.position)
		if last_pos > p and p > buff:
			last_pos = p
			obj_pos = pos.position
	
	return obj_pos
	
func get_idol():
	return idol.instance()
	
func get_chest():
	if randi() % 11 == 0:
		var type  = "chest_closed"
		var enemy_inst = null
		enemy_inst = enemy.instance()
		enemy_inst.enemy_type = type
		enemy_inst.iamasign_ttl = -1
		return enemy_inst
	else:
		return chest.instance()
	
func spawn_chest_and_stuff(only_chest=false, only_idol=false):
	randomize()
	reveal_doors()
	var do_chest = true
	var buff = 64
	var posibility = (randi() % 4)
	if (posibility) == 0:
		buff = 96
		do_chest = false
	
	var obj_pos = null
	if only_chest and Global.FLOOR_TYPE == Global.floor_types.altar:
		obj_pos = $pos20.position
	else:
		obj_pos = find_closest_player(buff)
		
	var obj_inst = null

	if only_idol and !Global.IDOLS[Global.CURRENT_FLOOR] == 1:
		obj_inst = get_idol()
	else:
		if only_chest or do_chest:
			obj_inst = get_chest()
		else:
			obj_inst = ItemPedestal.instance()
	
	get_parent().add_child(obj_inst)
	obj_inst.set_position(to_global(obj_pos))
	
	if !only_chest and do_chest and Global.pick_random([0, 0, 1]):
		obj_pos = find_farthest_to_chest(obj_inst, 0)
		obj_inst = ItemPedestal.instance()
		get_parent().add_child(obj_inst)
		obj_inst.set_position(to_global(obj_pos))
		
func spawn_enemy(fixed_enemies=false):
	if fixed_enemies or WAVE_COUNT < Global.get_floor_waves():
		WAVE_COUNT += 1
		var positions = get_children()
		
		var enemies
		if !fixed_enemies:
			enemies = Global.enemy_by_floor()
		else:
			enemies = Global.enemy_by_boss()
		
		for i in range(enemies.size()):
			positions.shuffle()
			var p = positions.pop_front()
			var type  = enemies[i]
			var enemy_inst = null
			
			if type == "bat":
				enemy_inst = bat_group.instance()
			else:
				enemy_inst = enemy.instance()
				if !fixed_enemies and type == "scorpion":
					if Global.pick_random([1, 1, 1, 1, 0]) == 0:
						type = "scorpion+"
				
				enemy_inst.enemy_type = type
				
			get_parent().add_child(enemy_inst)
			enemy_inst.global_position = p.global_position
	else:
		if !Global.FLOOR_OVER and get_tree().get_nodes_in_group("enemies").size() == 0:
			Global.FLOOR_OVER = true
			spawn_chest_and_stuff()
