extends KinematicBody2D
var life = 0
var iamasign_ttl = 0.9
var iamasign = true
var speed = 0
var player_chase = null

func _ready():
	$shadow.visible = false
	$sprite.animation = "sign"
	$area.add_to_group("enemies")

func _physics_process(delta):
	if !iamasign:
		$shadow.visible = true
		find_player()
		enemy_behaviour()
	else:
		if iamasign_ttl > 0:
			iamasign_ttl -= 1 * delta
		if iamasign_ttl <= 0:
			set_type()
			iamasign = false
			
func find_player():
	player_chase = get_tree().get_nodes_in_group("players")[0]
			
func enemy_behaviour():
	face_player()
	var player_direction = (player_chase.position - self.position).normalized()
	move_and_slide(speed * player_direction)
	
func face_player():
	if position.x > player_chase.position.x:
		$sprite.scale.x = 1
	else:
		$sprite.scale.x = -1
	
func set_type():
	$sprite.animation = "scorpion"
	speed = 100
	life = 1
	
func hit(dmg:= 1):
	if !iamasign:
		life -= dmg
		if life <= 0:
			die()

func die():
	if !iamasign:
		queue_free()
