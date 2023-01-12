extends Area2D
var _player = null
var speed = 80
var _enemy = []
export var ignore_waterfall = false

func _ready():
	add_to_group("big_block")
	$waterfall.visible = false
	
	if Global.FLOOR_TYPE != Global.floor_types.normal:
		queue_free()
	else:
		var chance = [false, false, false, true]
		if ignore_waterfall:
			chance = [false, true]
		
		if !Global.pick_random(chance):
			queue_free()
	
func _physics_process(delta):
	if ignore_waterfall:
		z_index = VisualServer.CANVAS_ITEM_Z_MAX
		if !$waterfall.visible:
			get_parent().hide_waterfall()
			
		$waterfall.visible = true
	else:
		z_index = VisualServer.CANVAS_ITEM_Z_MIN
	
	for e in _enemy:
		if e and is_instance_valid(e):
			e.position = e.position.move_toward($collider.global_position, delta * (speed))
	
	if _player:
		_player.position = _player.position.move_toward($collider.global_position, delta * (speed))
		if !_player.falling:
			_player = null

func _on_BigBlock_body_entered(body):
	if body.is_in_group("players"):
		if !Global.flying:
			_player = body
			body.fall()

func _on_BigBlock_area_entered(area):	
	if area.is_in_group("decorations"):
		area.destroy_silent()
	
	if area.is_in_group("enemies"):
		if !area.get_parent().flying:
			if area.get_parent().fall():
				_enemy.append(area.get_parent())
