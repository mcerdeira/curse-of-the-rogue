extends Area2D
var _player = null
var speed = 80
var _enemy = []

func _ready():
	z_index = VisualServer.CANVAS_ITEM_Z_MIN + 1
	#queue_free()
	if Global.FLOOR_TYPE != Global.floor_types.normal:
		pass
		#queue_free()
	pass
	
func _physics_process(delta):
	for e in _enemy:
		if e and is_instance_valid(e):
			e.position = e.position.move_toward($collider.global_position, delta * (speed))
	
	if _player:
		_player.position = _player.position.move_toward($collider.global_position, delta * (speed))
		if !_player.falling:
			_player = null

func _on_BigBlock_body_entered(body):
	if body.is_in_group("players"):
		_player = body
		body.fall()

func _on_BigBlock_area_entered(area):
	if area.is_in_group("enemies"):
		if !area.get_parent().flying:
			_enemy.append(area.get_parent())
			area.get_parent().fall()
