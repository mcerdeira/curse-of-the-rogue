extends Node2D
var current_timer = 0.5

func _physics_process(delta):
	current_timer -= 1 * delta
	if current_timer <= 0:
		current_timer = Global.reset_spawn_timer()
		spawn_enemy()
		
func spawn_enemy():
	pass
