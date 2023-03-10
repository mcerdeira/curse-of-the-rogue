extends Area2D
var taken = false
var particle = preload("res://scenes/particle2.tscn")
export var item_texture : Texture
export var item_texture_last : Texture
var item_description = ""
var item_long_description = ""
var last_idol = false
var do_action_ttl_total = 3.5
var do_action_ttl = do_action_ttl_total
var pixelated = 0
var do_action = false

func _ready():
	item_description = "GOLDEN IDOL"
	item_long_description = "From Floor " + str(Global.CURRENT_FLOOR)
	
func set_last():
	last_idol = true
	$sprite.animation = "last_idol"
	$FireParticles.visible = true

func _physics_process(delta):
	if taken:
		if last_idol and do_action:
			do_action_ttl -= 1 * delta
			if do_action_ttl <= do_action_ttl_total / 2:
				Global.set_visible_transition(true)
				pixelated += 200 * delta
				Global.pixelate(pixelated)
			
			if do_action_ttl <= 0:
				go_do_action()
		
		$sprite.scale.x += 350 * delta
		$sprite.scale.y -= 50 * delta
		$sprite.playing = false
		$sprite.frame = 1
		if $sprite.scale.x > 30:
			if !last_idol:
				queue_free()
			else:
				do_action = true
				visible = false
			
		if $sprite.scale.y <= 0:
			$sprite.scale.y = 0.1
			
func go_do_action():
	Global.CURRENT_FLOOR = 0
	Global.next_floor("intro")

func _on_Idol_body_entered(body):
	if !taken:
		if body.is_in_group("players"):
			emit()
			if last_idol:
				item_description = "GREAT GOLDEN IDOL"
				item_long_description = "The Final Idol"
			
			var HUD = get_tree().get_nodes_in_group("HUD")[0]
			HUD.set_message(item_description, item_long_description)
			
			if last_idol:
				Global.one_shot_items.append(item_texture_last)
			else:
				Global.one_shot_items.append(item_texture)
			
			body.add_heart(Global.health.size(), false)
			Global.idol_acquired()
			Global.play_sound(Global.WheelSfx)
			Global.refresh_hud()
			taken = true

func _destroy():
	emit()
	queue_free()

func emit():
	var p = particle.instance()
	get_parent().add_child(p)
	p.global_position = global_position
	p = particle.instance()
	get_parent().add_child(p)
	p.global_position = global_position
