extends Node2D
var delay = 0
var up = true
var count_total = 2
var count = 1
var last = false
var particle = preload("res://scenes/particle2.tscn")

func _physics_process(delta):
	if last:
		Global.shaker_obj.shake(3, 0.2)
	
	if up:
		delay -= 1 * delta
		if delay <= 0:
			up = false
			$AnimationPlayer.play("Anima")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Anima":
		count += 1
		if count < count_total:
			$AnimationPlayer.play("Anima")
			$AnimationPlayer.seek(3)
		elif count > count_total:
			if last:
				Global.LOGIC_PAUSE = false
			queue_free()
		
		
