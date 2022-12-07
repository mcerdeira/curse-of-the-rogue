extends Area2D
var ttl = 0.3
var ChestAnimation = preload("res://scenes/ChestAnimation.tscn")

func _ready():
	$collider.set_deferred("disabled", true)
	var bullets = get_tree().get_nodes_in_group("enemybullets")
	for b in bullets:
		b.destroy()

func _physics_process(delta):
	if ttl > 0:
		ttl -= 1 * delta
		if ttl <= 0:
			$collider.set_deferred("disabled", false)

func open_chest():
	var player = get_tree().get_nodes_in_group("players")[0]
	$sprite.animation = "opened"
	var chest = ChestAnimation.instance()
	var root = get_node("/root/Main")
	root.add_child(chest)
	chest.set_position(player.position)

func _on_Chest_body_entered(body):
	if body.is_in_group("players") and $sprite.animation == "closed":
		open_chest()
