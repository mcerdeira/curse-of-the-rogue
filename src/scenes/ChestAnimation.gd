extends Node2D
var ttl = 5

func _physics_process(delta):
	ttl -= 1 * delta
	if ttl <= 0:
		Global.LOGIC_PAUSE = false
		queue_free()

func _ready():
	Global.LOGIC_PAUSE = true
	z_index = VisualServer.CANVAS_ITEM_Z_MAX
	var reward_total = Global.get_reward_floor() * Global.max_combo
	Global.gems += reward_total
	$gems_total.text = str(reward_total)
	$gems.text = str(Global.get_reward_floor()) + " x " + str(Global.max_combo) + "(combo)"           
