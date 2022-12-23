extends AnimatedSprite

func _ready():
	var posi = ["1", "1", "2", "2", "3", "no", "no"]
	animation = Global.pick_random(posi)

func _physics_process(delta):
	z_index = global_position.y + 16
