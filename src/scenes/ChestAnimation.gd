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
	var max_combo = Global.max_combo
	if Global.FLOOR_TYPE == Global.floor_types.intro or Global.FLOOR_TYPE == Global.floor_types.boss or Global.FLOOR_TYPE == Global.floor_types.final_boss:
		max_combo = 1
	
	z_index = VisualServer.CANVAS_ITEM_Z_MAX
	var reward_floor = Global.get_reward_floor()
	var reward_total = reward_floor * max_combo
	var adi = ""
	if Global.cherry:
		reward_total *= 2
		adi = " x 2"
	
	Global.add_extra_display("gems", reward_total)
	
	$gems_total.text = str(reward_total)
	if Global.FLOOR_TYPE == Global.floor_types.intro or Global.FLOOR_TYPE == Global.floor_types.boss or Global.FLOOR_TYPE == Global.floor_types.final_boss:
		$gems.text = ""
	else:
		$gems.text = str(reward_floor) + " x " + str(Global.max_combo) + "(best combo)" + adi

	yield(get_tree().create_timer(.5), "timeout") 
	Global.hide_hud_extras("gems")
	Global.gems += reward_total
