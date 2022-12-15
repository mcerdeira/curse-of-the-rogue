extends Particles2D
var _texture = preload("res://sprites/smoke.png")
export var infinite = false
var color = null

func _ready():
	one_shot = true
	
func _physics_process(delta):
	if color != null:
		modulate = color
	
	if one_shot and infinite:
		one_shot = false
	
func init():
	texture = _texture

func _on_Timer_timeout():
	if !infinite:
		queue_free()
	else:
		emitting = true
