extends Node2D
var total_idols = 0
var some_pressed = false
var some_pressed_ttl = 3
var player = null
var what = ""
var done = false
var LevelUp = null
var Chamber = null

func _ready():
	LevelUp = load("res://scenes/LevelUp.tscn")
	Global.normal_cursor()
	z_index = VisualServer.CANVAS_ITEM_Z_MAX
	player = get_tree().get_nodes_in_group("players")[0]
	
func _physics_process(delta):
	if some_pressed and !done:
		visible = false
		Global.shaker_obj.shake(30, 0.2)
		some_pressed_ttl -= 1 * delta
		var item_description = "BLESSED!!!"
		var item_long_description = ""
		if some_pressed_ttl <= 0:
			Global.play_sound(Global.IdolBlessSfx)
			done = true
			player.bleseed()
			if what == "dmg":
				player.add_damage(1)
			elif what == "life":
				player.add_total_hearts(1)
				player.add_heart(Global.health.size(), false)
			elif what == "speed":
				player.add_speed(1)
			elif what == "melee_speed":
				player.add_melee(0.5)
			elif what == "shoot_speed":
				player.add_shoot_speed(1)
			elif what == "gems":
				player.add_gem(1000)
				
			Global.IDOL_PERKS.append(what)
			Global.PLAYER_LVL += 1
			
			total_idols -= 1
			
			Chamber.eval_idols()
			
			if total_idols > 0:
				var levelup = LevelUp.instance()
				levelup.total_idols = total_idols
				levelup.Chamber = Chamber
				var root = get_node("/root/Main/CanvasLayer")
				root.add_child(levelup)
			
			if total_idols <= 0:
				Global.custom_cursor()
				Global.GETTING_PERKS = false
				Global.LOGIC_PAUSE = false
				var HUD = get_tree().get_nodes_in_group("HUD")[0]
				HUD.set_message(item_description, item_long_description)
				
			queue_free()

func _on_btn_dmg_pressed():
	if !some_pressed:
		what = "dmg"
		$bless_description.text = "Increases your Melee Damage, permanently..."
	
func _on_btn_life_pressed():
	if !some_pressed:
		what = "life"
		$bless_description.text = "Gives your an Extra Heart, forever..."
			
func _on_btn_speed_pressed():
	if !some_pressed:
		what = "speed"
		$bless_description.text = "Increases your Speed, permanently"

func _on_btn_OK_pressed():
	if !some_pressed and what != "":
		some_pressed = true

func _on_btn_melee_speed_pressed():
	if !some_pressed:
		what = "melee_speed"
		$bless_description.text = "Increases your Melee Attack Speed, permanently"

func _on_btn_shoot_speed_pressed():
	if !some_pressed:
		what = "shoot_speed"
		$bless_description.text = "Increases your Range Attack Speed, permanently"

func _on_btn_gems_pressed():
	if !some_pressed:
		what = "gems"
		$bless_description.text = "Gives you 1000 gems"
