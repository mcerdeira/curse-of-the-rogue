extends Area2D
var player_in_ttl = 0.3
var player_in = null
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
		z_index = 1 #VisualServer.CANVAS_ITEM_Z_MIN
		if !$waterfall.visible:
			get_parent().hide_waterfall()
			
		$waterfall.visible = true
	else:
		z_index = VisualServer.CANVAS_ITEM_Z_MIN
	
	for e in _enemy:
		if e and is_instance_valid(e):
			e.position = e.position.move_toward($collider.global_position, delta * (speed))
	
	if  !_player and player_in and !player_in.falling and player_in.inv_time <=0:
		player_in_ttl -= 1 * delta
		if player_in_ttl <= 0:
			player_in_ttl = 2
			_player = player_in
			_player.fall()
	
	if _player:
		_player.position = _player.position.move_toward($collider.global_position, delta * (speed))
		if !_player.falling:
			_player = null
			var a = player_in

func _on_BigBlock_body_entered(body):
	if body.is_in_group("players"):
		if !Global.flying:
			player_in = body
			_player = body
			body.fall()

func _on_BigBlock_area_entered(area):	
	if area.is_in_group("playerbullet"):
		if area.get_parent().type == "bomb":
			_enemy.append(area.get_parent())
			area.get_parent().fall()
	
	if area.is_in_group("decorations"):
		area.destroy_silent()
	
	if area.is_in_group("enemies"):
		if !area.get_parent().flying:
			if area.get_parent().fall():
				_enemy.append(area.get_parent())

func _on_BigBlock_body_exited(body):
	if body.is_in_group("players"):
		if !Global.flying:
			player_in_ttl = 2
			player_in = null
