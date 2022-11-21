extends KinematicBody2D
var movement = Vector2.ZERO
var speed = 150

func _physics_process(delta):
	var move = false
	movement = Vector2.ZERO
			
	if Input.is_action_pressed("left"):
		movement.x = -speed
		move = true
		$sprite.scale.x = -1
	elif Input.is_action_pressed("right"):
		movement.x = speed
		move = true
		$sprite.scale.x = 1
		
	if Input.is_action_pressed("down"):
		movement.y = speed
		move = true
		$sprite.animation = "default"
	elif Input.is_action_pressed("up"):
		movement.y = -speed
		move = true
		$sprite.animation = "back"
	
	movement = move_and_slide(movement, Vector2.UP)
	
	$sprite.playing = move
	if !move:
		$sprite.animation = "default"
		$sprite.frame = 0
