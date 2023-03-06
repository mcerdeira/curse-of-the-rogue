extends Node2D
var particle = preload("res://scenes/particle2.tscn")
var speed = 0

func emit():
	var p = particle.instance()
	var root = get_node("/root/Main")
	root.add_child(p)
	p.global_position = global_position

func _ready():
	z_index = VisualServer.CANVAS_ITEM_Z_MAX
	$sprite.animation = Global.pick_random(["one", "two"])
	$sprite.rotation_degrees = randi()% 360
	speed = 200 + (randi() % 200) + (randi() % 200) + (randi() % 200)
	var sca = Global.pick_random([1, 2.5, 2])
	$sprite.scale.x = sca
	$sprite.scale.y = sca

func _physics_process(delta):
	position.y += speed * delta
	if position.y >= 650:
		queue_free()
		
	if randi() % 30 == 0:
		emit()
