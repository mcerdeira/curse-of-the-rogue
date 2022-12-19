extends Node

var arrow = preload("res://sprites/crosshair.png")
var LOGIC_PAUSE = false
var FIRST = true
var TOTAL_FLOORS = 7
var CURRENT_FLOOR = 0
var ENEMY_SPAWN_TIMER_TOTAL = 10
var ENEMY_SPAWN_TIMER = ENEMY_SPAWN_TIMER_TOTAL
var poisoned_color = Color8(100, 196, 27)
var infected_color = Color8(203, 54, 220)
var FLOOR_TYPE = ""
var FLOOR_WAVES = [-1, 1, 2, 3, 3, 4, 4, 5]
var FLOOR_ROOMS = [-1, 2, 3, 4, 5, 6, 6, 7]
var FLOOR_REWARD = [-1, 10, 10, 20, 20, 30, 30, 50]
var FLOOR_ENEMIES = [
	-1,
	["scorpion"], 
	["bat"], 
	["scorpion", "bat"],
	["skeleton"],
	["skeleton","scorpion"],
	["scorpion", "bat", "skeleton"],
]

var GAME_OVER = false
var FLOOR_OVER = false

var max_combo = 0
var current_combo = 0
var combo_time = 0
var combo_time_total = 2.3

var primary_weapon = ""
var secondary_weapon = ""
var poison = false
var temp_poison = false
var keys = 0
var melee_rate = 0
var melee_rate_total = 0
var attack = 0
var speed = 0
var health = 0
var shield = 0
var gems = 0
var bad_luck = 0
var total_bad_luck = 0
var zombie = false

enum floor_types {
	intro,
	normal,
	boss,
	altar,
	shop,
	supershop
}

var PREMIUM_ITEMS = {
	"wolfe_bite": {
		"name": "wolfe_bite",
		"description": "Wolf Bite",
		"long_description": "",
		"price": 350,
		"type": "passive"
	},
	"brain": {
		"name": "brain",
		"description": "Brain",
		"long_description": "",
		"price": 350,
		"type": "passive"
	},
	"poison": {
		"name": "poison",
		"description": "Poisonous touch",
		"long_description": "",
		"price": 250,
		"type": "passive"
	},
	"speedup": {
		"name": "speedup",
		"description": "Speed++",
		"long_description": "",
		"price": 150,
		"type": "passive"
	},
	"meleeup": {
		"name": "meleeup",
		"description": "Melee Speed++",
		"long_description": "",
		"price": 150,
		"type": "passive"
	},
	"damageup": {
		"name": "damageup",
		"description": "Damage++",
		"long_description": "",
		"price": 150,
		"type": "passive"
	},
	"luckup": {
		"name": "luckup",
		"description": "Luck++",
		"long_description": "",
		"price": 150,
		"type": "passive"
	},
}

var ITEMS = {
	"blue_heart": {
		"name": "blue_heart",
		"description": "",
		"long_description": "",
		"price": 50
	},
	"green_heart": {
		"name": "green_heart",
		"description": "",
		"long_description": "",
		"price": 75
	},
	"empty_heart": {
		"name": "empty_heart",
		"description": "",
		"long_description": "",
		"price": 150
	},
	"normal_heart": {
		"name": "normal_heart",
		"description": "",
		"long_description": "",
		"price": 25
	}
}

var BOSS_HEADS = {
	"Pig" : {
		"name": tr("Pig"),
		"dialog": tr("You are going to die!"),
	},
	"Demon": {
		"name": tr("Demon"),
		"dialog": tr("I'll drag you to hell!")
	}
}

var BOSS_BODIES = {
	"Pig" : {
		"name": tr("pigglet"),
		"movement": "random",
	},
	"Demon": {
		"name": tr("demonic"),
		"movement": "chase",
	}
}

var BOSS_ELEMENTS = {
	"Fire" : {
		"name": tr("of fire"),
		"weapon": "balls_of_fire",
	},
	"Ice": {
		"name": tr("of ice"),
		"weapon": "ice_zones",
	}
}

func enemy_by_floor():
	return FLOOR_ENEMIES[CURRENT_FLOOR]

func _ready():
	Input.set_custom_mouse_cursor(arrow)
	initialize()
	init_room()
	
func get_reward_floor():
	var reward = FLOOR_REWARD[CURRENT_FLOOR]
	var rnd = pick_random([0, 1, 3, 5, 7, 9])
	return reward + rnd
	
func init_room():
	if FIRST:
		FIRST = false
		FLOOR_TYPE = floor_types.intro
		
func get_random_item():
	randomize()
	if Global.pick_random([1, 1, 1, 0]) == 1:
		return pick_random(ITEMS)
	else:
		return pick_random(PREMIUM_ITEMS)
	
func get_random_premium_item():
	randomize()
	if Global.pick_random([1, 1, 1, 0]) == 1:
		return pick_random(PREMIUM_ITEMS)
	else:
		return pick_random(ITEMS)

func initialize():
	FIRST = true
	GAME_OVER = false
	FLOOR_OVER = false
	LOGIC_PAUSE = false
	FLOOR_TYPE = ""
	CURRENT_FLOOR = 0
	
	max_combo = 0
	current_combo = 0
	combo_time = 0
	combo_time_total = 2.3

	primary_weapon = "Whip"
	secondary_weapon = "Empty"
	
	speed = 150
	total_bad_luck = 100
	bad_luck = total_bad_luck
	attack = 1

	keys = 0
	shield = 0
	health = [1, 1, 1]

	melee_rate_total = 1
	melee_rate = 0
	
	gems = 0
	
	poison = false
	temp_poison = false
	zombie = false

func sustain():
	combo_time = 0.5

func add_combo():
	combo_time = combo_time_total
	current_combo += 1
	if current_combo > max_combo:
		max_combo = current_combo

func get_floor_waves():
	return FLOOR_WAVES[CURRENT_FLOOR]
	
func refresh_hud():
	var HUD = get_tree().get_nodes_in_group("HUD")[0]
	HUD.update_health()

func reset_spawn_timer():
	ENEMY_SPAWN_TIMER_TOTAL = ENEMY_SPAWN_TIMER_TOTAL # TODO: Recalcular
	ENEMY_SPAWN_TIMER = ENEMY_SPAWN_TIMER_TOTAL
	return ENEMY_SPAWN_TIMER
	
func next_floor(type):
	if type == "next":
		FLOOR_TYPE = floor_types.normal
		Global.FLOOR_OVER = false
		if CURRENT_FLOOR < TOTAL_FLOORS:
			CURRENT_FLOOR += 1
	elif type == "shop":
		FLOOR_TYPE = floor_types.shop
	elif type == "supershop":
		FLOOR_TYPE = floor_types.supershop
	elif type == "altar":
		FLOOR_TYPE = floor_types.altar
		
	Global.FLOOR_OVER = false
	Global.LOGIC_PAUSE = false
	get_tree().reload_current_scene()
	
func pay_price(_player, price_what, price_amount):
	if price_amount == 0:
		return true
		
	if price_what == "gems":
		if Global.gems >= price_amount:
			_player.add_gem(-price_amount)
			return true
	elif price_what == "life":
			if Global.zombie:
				return true
			else:
				_player.hit(price_amount, true)
				return true
	elif price_what == "keys":
		if Global.keys >= price_amount:
			Global.keys -= price_amount
			return true
	return false
	
func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action_pressed("restart_game"):
		initialize()
		init_room()
		get_tree().reload_current_scene()
	if event.is_action_pressed("quit_game"):
		get_tree().quit()

func pick_random(container):
	if typeof(container) == TYPE_DICTIONARY:
		return container.values()[randi() % container.size() ]
	assert( typeof(container) in [
			TYPE_ARRAY, TYPE_COLOR_ARRAY, TYPE_INT_ARRAY,
			TYPE_RAW_ARRAY, TYPE_REAL_ARRAY, TYPE_STRING_ARRAY,
			TYPE_VECTOR2_ARRAY, TYPE_VECTOR3_ARRAY
			], "ERROR: pick_random" )
	return container[randi() % container.size()]
