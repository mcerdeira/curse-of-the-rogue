extends Node2D
var delay = 0
var up = true
var count_total = 3
var count = 1
var last = false
var num = -1
var particle = preload("res://scenes/particle2.tscn")
var LevelUp = preload("res://scenes/LevelUp.tscn")
var done = false
var done_ttl = 2.3
var Chamber = null
var total_idols = 0

func _physics_process(delta):
	if done:
		z_index = VisualServer.CANVAS_ITEM_Z_MAX
		$Node2D/sprite.scale.x += 10 * delta
		$Node2D/sprite.scale.y = $Node2D/sprite.scale.x
		
		done_ttl -= 1 * delta
		if done_ttl <= 0:
			Global.IDOLS[num] = 2
			if last:
				Chamber.eval_idols()
				Global.play_sound(Global.AltarSfx)
				
				var levelup = LevelUp.instance()
				levelup.total_idols = total_idols
				var root = get_node("/root/Main")
				root.add_child(levelup)
				
			Global.one_shot_items.remove(0)
			Global.refresh_hud()
			queue_free()
	
	if last:
		Global.shaker_obj.shake(5, 0.2)
	
	if up:
		delay -= 1 * delta
		if delay <= 0:
			up = false
			$AnimationPlayer.play("Anima")

func _on_AnimationPlayer_animation_finished(anim_name):
	if !done and anim_name == "Anima":
		count += 1
		if count < count_total:
			$AnimationPlayer.play("Anima")
			$AnimationPlayer.seek(3)
		elif count >= count_total:
			done = true
