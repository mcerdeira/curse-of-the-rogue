extends Node2D
var started = false
var do_action_ttl_total = 3.5
var do_action_ttl = do_action_ttl_total
var pixelated = 0
var do_action = false

func _ready():
	add_to_group("bonfire")
	if Global.FLOOR_TYPE != Global.floor_types.altar and Global.FLOOR_TYPE != Global.floor_types.shop and Global.FLOOR_TYPE != Global.floor_types.supershop:
		queue_free()
		return

func _physics_process(delta):
	if do_action:
		do_action_ttl -= 1 * delta
		if do_action_ttl <= do_action_ttl_total / 2:
			Global.set_visible_transition(true)
			pixelated += 200 * delta
			Global.pixelate(pixelated)
		
		if do_action_ttl <= 0:
			reset_player_status()
			go_do_action()
			
func reset_player_status():
	pass
			
func go_do_action():
	Global.next_floor("intro")

func _on_BonFire_body_entered(body):
	if !started and body.is_in_group("players"):
		$FireParticles.visible = true
		$Dialog.visible = true
		started = true

func _on_Button_pressed():
	do_action = true

func _on_Button2_pressed():
	$Dialog.visible = false
	$FireParticles.visible = false
	started = false
