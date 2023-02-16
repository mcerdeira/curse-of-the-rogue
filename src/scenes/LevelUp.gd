extends Node2D
var total_idols = 0
var some_pressed = false
var some_pressed_ttl = 3
var player = null
var what = ""
var done = false

func _ready():
	Global.normal_cursor()
	z_index = VisualServer.CANVAS_ITEM_Z_MAX
	player = get_tree().get_nodes_in_group("players")[0]
	
func _physics_process(delta):
	if some_pressed and !done:
		visible = false
		Global.shaker_obj.shake(30, 0.2)
		some_pressed_ttl -= 1 * delta
		var item_description = "BLESSED!"
		var item_long_description = ""
		if some_pressed_ttl <= 0:
			done = true
			player.bleseed()
			Global.LOGIC_PAUSE = false
			if what == "dmg":
				item_long_description = "Damage"
				player.add_damage(1)
			elif what == "life":
				item_long_description = "Life"
				player.add_total_hearts(1)
				player.add_heart(Global.health.size(), false)
			elif what == "speed":
				item_long_description = "Speed"
				player.add_speed(1)
				
			var HUD = get_tree().get_nodes_in_group("HUD")[0]
			HUD.set_message(item_description, item_long_description)

func _on_btn_dmg_pressed():
	if !some_pressed:
		what = "dmg"
		$bless_description.text = "Increases your melee damage, permanently..."
	
func _on_btn_life_pressed():
	if !some_pressed:
		what = "life"
		$bless_description.text = "Gives your an extra heart, forever..."
			
func _on_btn_speed_pressed():
	if !some_pressed:
		what = "speed"
		$bless_description.text = "Increases your speed, permanently"

func _on_btn_OK_pressed():
	if !some_pressed and what != "":
		some_pressed = true
