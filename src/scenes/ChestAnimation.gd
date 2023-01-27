extends Node2D
var ttl = 3

func _physics_process(delta):
	ttl -= 1 * delta
	if ttl <= 0:
		Global.LOGIC_PAUSE = false
		queue_free()

func _ready():
	Global.play_sound(Global.ChestAnimationSfx)
	Global.LOGIC_PAUSE = true
	z_index = VisualServer.CANVAS_ITEM_Z_MAX
	var reward_floor = Global.get_reward_floor()
	var reward_total = reward_floor * Global.max_combo
	var adi = ""
	if Global.cherry:
		reward_total *= 2
		adi = " x 2"
	
	Global.add_extra_display("gems", reward_total)
	
	$gems_total.text = str(reward_total)
	$gems.text = str(reward_floor) + " x " + str(Global.max_combo) + "(combo)" + adi

	yield(get_tree().create_timer(.5), "timeout") 
	Global.hide_hud_extras("gems")
	Global.gems += reward_total
