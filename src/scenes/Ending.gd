extends Node2D
var FallingWalls = preload("res://scenes/FallingWalls.tscn")
var ttl = 0
var pixelated = 0
var do_action_ttl_total = 10
var do_action_ttl = do_action_ttl_total

func go_do_action():
	Global.goto_credits()

func _physics_process(delta):
	do_action_ttl -= 1 * delta
	if do_action_ttl <= do_action_ttl_total / 2:
		Global.set_visible_transition(true)
		pixelated += 200 * delta
		Global.pixelate(pixelated)
	
	if do_action_ttl <= 0:
		go_do_action()
	
	Global.shaker_obj.shake(15, 0.2)
	ttl -= 1 * delta
	if ttl <= 0:
		ttl = 1.2
		for i in range(15):
			var wall = FallingWalls.instance()
			get_parent().add_child(wall)
			var p = Global.SPAWNER.get_random_point()
			
			wall.set_position(Vector2(p.position.x, -10))
