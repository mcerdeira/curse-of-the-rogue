extends KinematicBody2D
var life = 1
var iamasign_ttl = 0.9
var iamasign = true

func _ready():
	$sprite.animation = "sign"
	$area.add_to_group("enemies")

func _physics_process(delta):
	iamasign_ttl -= 1 * delta
	if iamasign_ttl <= 0:
		set_type()
		iamasign = false
		
func set_type():
	$sprite.animation = "scorpion"
	life = 1
	
func hit(dmg:= 1):
	if !iamasign:
		life -= dmg
		if life <= 0:
			die()

func die():
	if !iamasign:
		queue_free()
