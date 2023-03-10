extends Node2D
var do_action = false
var do_action_ttl_total = 2
var do_action_ttl = do_action_ttl_total
var pixelated = 0
var player = null
var bonfire = null

func _ready():
	Global.BonFireDialog = self
	visible = false

func _on_Button_pressed():
	visible = false
	do_action = true
	
func start(body, _bonfire):
	bonfire = _bonfire
	bonfire.burn()
	player = body
	Global.LOGIC_PAUSE = true
	visible = true
	Global.normal_cursor()
	
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
			
func go_do_action():
	Global.CURRENT_FLOOR = 0
	Global.next_floor("intro")
	
func reset_player_status():
	Global.reset_health()

func _on_Button2_pressed():
	bonfire.burn_off()
	Global.LOGIC_PAUSE = false
	visible = false
	Global.custom_cursor()
