extends KinematicBody2D
export var type = ""
var effect_name = ""
var player_chase = null
var player_direction = null
var fake = false
var speed = 0
var dmg = 0
var particle = preload("res://scenes/particle2.tscn")
export var dir = Vector2.ZERO
export var lander = false

var ttl = 5
var from = ""

func _ready():
	add_to_group("enemybullets")

func emit():
	var p = particle.instance()
	var parent = get_parent()
	if lander:
		parent = get_parent().get_parent()
	
	parent.add_child(p)	
	p.global_position = global_position
	p = particle.instance()
	parent.add_child(p)
	p.global_position = global_position
	
func is_fire_ball():
	return type == "poison_ball" or type == "ice_ball" or type == "fire_ball"

func init_again(_from):
	$sprite.animation = type
	from = _from
	
func init_fake():
	fake = true
	speed = Global.pick_random([400, 350, 500])
	var sca = Global.pick_random([1, 2.5, 2])
	$sprite.animation = type
	$sprite.scale.x = sca
	$sprite.scale.y = sca

func _physics_process(delta):
	if fake and position.y <= -1000:
		queue_free()
	
	if type == "fire_trail":
		dmg = 1
		z_index = VisualServer.CANVAS_ITEM_Z_MIN + 1
		ttl -= 1 * delta
		if ttl <= 0:
			destroy()
	
	if type == "bone" or is_fire_ball():
		z_index = VisualServer.CANVAS_ITEM_Z_MAX - 1
		if !fake and player_chase == null:
			if is_fire_ball():
				speed = 200
			else:
				speed = 150
			dmg = 1
			player_chase = get_tree().get_nodes_in_group("players")[0]
			player_direction = (player_chase.position - self.position).normalized()
			$sprite.look_at(player_chase.global_position)
		
		if lander:
			speed = 300
		
		$sprite.animation = type
		if dir != Vector2.ZERO:
			move_and_slide(speed * dir)
			$sprite.look_at(to_global(dir))
		else:
			move_and_slide(speed * player_direction)
			if !is_fire_ball():
				$sprite.rotation += 10 * delta

func destroy():
	if lander:
		get_parent().queue_free()
		
	emit()
	queue_free()

func _on_area_body_entered(body):
	if !fake and !lander and body.name == "Walls":
		destroy()
	if !fake and body.is_in_group("players"):
		body.hit(dmg, from, false, effect_name)
		destroy()

func _on_area_area_entered(area):
	if lander and area.is_in_group("lander"):
		destroy()
