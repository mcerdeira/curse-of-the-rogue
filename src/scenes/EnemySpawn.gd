extends Node2D
var current_timer = 0.5
var enemy = preload("res://scenes/Enemy.tscn")

func _physics_process(delta):
	current_timer -= 1 * delta
	if current_timer <= 0:
		current_timer = Global.reset_spawn_timer()
		spawn_enemy()
		
func spawn_enemy():
	var positions = get_children()
	for i in range(4):
		var p = Global.pick_random(positions)
		
		var enemy_inst = enemy.instance()
		get_parent().add_child(enemy_inst)
		enemy_inst.set_position(to_global(p.position))
