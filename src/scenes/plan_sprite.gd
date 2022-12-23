extends AnimatedSprite
var particle = preload("res://scenes/particle2.tscn")
var vegetation = false

func _ready():
	initialize_me()

func _physics_process(delta):
	if !vegetation and get_parent().vegetation:
		vegetation = true
		initialize_me()
	
	z_index = global_position.y + 16
	
func initialize_me():
	var posi = []
	if vegetation:
		posi = ["1", "1", "2", "2", "no", "no", "no", "no"]
	else:
		posi = ["1", "1", "2", "2", "3", "no", "no", "no", "no", "no"]
	animation = Global.pick_random(posi)
	
func emit():
	var p = particle.instance()
	get_parent().add_child(p)
	p.global_position = global_position
	p = particle.instance()
	get_parent().add_child(p)
	p.global_position = global_position

func _destroy():
	emit()
	queue_free()
