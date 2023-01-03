extends Area2D
var ttl = 0.3
var ChestAnimation = preload("res://scenes/ChestAnimation.tscn")
var particle = preload("res://scenes/particle2.tscn")
var price = 0
var price_what = "keys"

func emit():
	for i in range(2):
		var p = particle.instance()
		var root = get_node("/root/Main")
		root.add_child(p)
		p.global_position = global_position

func _ready():
	if Global.FLOOR_TYPE == Global.floor_types.altar:
		if Global.pick_random([0, 1]) == 1:
			price = 1
			$sprite.animation = "closed_key"
	
	$collider.set_deferred("disabled", true)
	var bullets = get_tree().get_nodes_in_group("enemybullets")
	for b in bullets:
		b.destroy()
		
	yield(get_tree().create_timer(0.1), "timeout")
	emit()

func _physics_process(delta):
	if ttl > 0:
		ttl -= 1 * delta
		if ttl <= 0:
			$collider.set_deferred("disabled", false)

func open_chest():
	Global.play_sound(Global.ChestOpenSfx)
	var player = get_tree().get_nodes_in_group("players")[0]
	$sprite.animation = "opened"
	var chest = ChestAnimation.instance()
	var root = get_node("/root/Main")
	root.add_child(chest)
	chest.set_position(player.position)

func _on_Chest_body_entered(body):
	if body.is_in_group("players") and ($sprite.animation == "closed" or $sprite.animation == "closed_key"):
		if price == 0 or Global.pay_price(body, price_what, price):
			open_chest()
