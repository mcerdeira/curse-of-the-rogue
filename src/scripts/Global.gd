extends Node
var Muted = false
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
var FLOOR_WAVES = [-1, 1, 1, 3, 3, 4, 4, 5]
var FLOOR_REWARD = [-1, 10, 10, 20, 20, 30, 30, 50]

var GAME_OVER = false
var FLOOR_OVER = false
var MainTheme = null
var ShopAlterTheme = null
var MainThemePlaying = false

var max_combo = 0
var current_combo = 0
var combo_time = 0
var combo_time_total = 2.3

var primary_weapon = ""
var secondary_weapon = ""
var automatic_weapon = ""
var poison = false
var temp_poison = false
var keys = 0
var melee_rate = 0.0
var melee_rate_total = 0.0
var attack = 0
var speed = 0
var health = 0
var shield = 0
var gems = 0
var bad_luck = 0
var total_bad_luck = 0
var zombie = false
var shoot_speed = 0.0
var shoot_speed_total = 0.0

var altar_points = 0
var altar_lifes = 0
var altar_gems = 0
var altar_level = 0

var POINTS_BASE = 9
var POINTS_X = 1
var POINTS_Y = 3

enum floor_types {
	intro,
	normal,
	boss,
	altar,
	shop,
	supershop
}

var PREMIUM_ITEMS = {
	"shot_gun": {
		"name": "shot_gun",
		"description": "Shotgun",
		"long_description": "Spread of bullets",
		"price": 300,
		"type": "passive"
	},
	"knife": {
		"name": "knife",
		"description": "Knife",
		"long_description": "Piercing Knife",
		"price": 300,
		"type": "passive"
	},
	"key": {
		"name": "key",
		"description": "Key",
		"long_description": "A Key",
		"price": 150,
		"type": "consumable"
	},	
	"wolfe_bite": {
		"name": "wolfe_bite",
		"description": "Wolf Bite",
		"long_description": "A wolf bite",
		"price": 350,
		"type": "passive"
	},
	"brain": {
		"name": "brain",
		"description": "Brain",
		"long_description": "Yummy for zombies",
		"price": 350,
		"type": "passive"
	},
	"poison": {
		"name": "poison",
		"description": "Poison Drop",
		"long_description": "Poisonous touch",
		"price": 250,
		"type": "passive"
	},
	"shoot_speed_up": {
		"name": "shoot_speed_up",
		"description": "Adrenaline",
		"long_description": "Shoot Speed Up",
		"price": 200,
		"type": "passive"
	},
	"speedup": {
		"name": "speedup",
		"description": "Speed boots",
		"long_description": "Speed Up",
		"price": 150,
		"type": "passive"
	},
	"meleeup": {
		"name": "meleeup",
		"description": "Chocolate Bar",
		"long_description": "Melee Speed Up",
		"price": 150,
		"type": "passive"
	},
	"damageup": {
		"name": "damageup",
		"description": "Ramen Bowl",
		"long_description": "Damage Up",
		"price": 150,
		"type": "passive"
	},
	"luckup": {
		"name": "luckup",
		"description": "Clover",
		"long_description": "Luck Up",
		"price": 150,
		"type": "passive"
	},
}

var ITEMS = {
	"key": {
		"name": "key",
		"description": "Key",
		"long_description": "A Key",
		"price": 150,
		"type": "consumable"
	},
	"blue_heart": {
		"name": "blue_heart",
		"description": "Blue Heart",
		"long_description": "Shield",
		"price": 50
	},
	"green_heart": {
		"name": "green_heart",
		"description": "Green Heart",
		"long_description": "Shield + Poison",
		"price": 75
	},
	"empty_heart": {
		"name": "empty_heart",
		"description": "Empty Heart",
		"long_description": "Heart Container",
		"price": 150
	},
	"normal_heart": {
		"name": "normal_heart",
		"description": "Heart",
		"long_description": "Fills a Heart",
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

var ENEMY_PATTERNS = [
	-1,
	[
		["scorpion", "scorpion", "scorpion"],
		["ghost"],
		["bat"],
		["dead_fire"],
		["scorpion"],
		["skeleton"],
	],
	[
		["scorpion", "scorpion", "scorpion", "scorpion"],
		["scorpion", "scorpion", "scorpion", "bat"],
		["scorpion", "scorpion", "bat", "bat"],
		["scorpion", "scorpion"]
	],
	[
		["scorpion", "scorpion", "scorpion", "scorpion"],
		["bat", "scorpion", "bat", "bat"],
		["bat", "bat"],
		["ghost", "ghost"],
	],
	[	
		["dead_fire", "dead_fire", "dead_fire", "dead_fire", "dead_fire"],
		["skeleton", "skeleton", "skeleton", "skeleton", "dead_fire"],
		["scorpion", "scorpion", "skeleton", "skeleton", "dead_fire"],
		["bat", "dead_fire", "dead_fire", "dead_fire", "dead_fire"],
		["dead_fire", "dead_fire"],
	],
	[
		["ghost", "ghost"],
		["dead_fire", "dead_fire", "ghost", "ghost", "ghost"],
		["skeleton", "skeleton", "skeleton", "skeleton", "ghost"],
		["ghost", "scorpion", "scorpion", "scorpion", "scorpion", "scorpion"],
	],
	[],
]

func _ready():
	MainTheme = load("res://music/main_theme.mp3")
	ShopAlterTheme = load("res://music/shop_altar_theme.mp3")
	Input.set_custom_mouse_cursor(arrow)
	initialize()
	init_room()
	
func calc_points_level():
	return POINTS_BASE + pow((altar_level / POINTS_X), POINTS_Y)

func enemy_by_floor():
	randomize()
	# floor  enemies
	#	1		  3
	#	2		  4
	#	3		  4
	#	4		  5
	#	5		  5
	#	6		  6
	#	7		  6
	return Global.pick_random(ENEMY_PATTERNS[CURRENT_FLOOR])
	
func get_reward_floor():
	var reward = FLOOR_REWARD[CURRENT_FLOOR]
	var rnd = pick_random([0, 1, 3, 5, 7, 9])
	return reward + rnd
	
func init_room():
	if FIRST:
		FIRST = false
		FLOOR_TYPE = floor_types.intro
		
func get_random_item(chest_replacement:=false):
	randomize()
	if chest_replacement or Global.pick_random([1, 1, 1, 1, 0]) == 1:
		return pick_random(ITEMS)
	else:
		return pick_random(PREMIUM_ITEMS)
	
func get_random_premium_item():
	randomize()
	if Global.pick_random([1, 1, 1, 1, 0]) == 1:
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

	primary_weapon = "whip"
	secondary_weapon = "empty"
	automatic_weapon = "empty"
	
	speed = 150.00
	total_bad_luck = 100.00
	bad_luck = total_bad_luck
	attack = 1

	keys = 0
	shield = 0
	health = [1, 1, 1]

	melee_rate_total = 1.0
	melee_rate = 0
	
	shoot_speed_total = 5.0
	shoot_speed = 0
	
	gems = 0
	
	poison = false
	temp_poison = false
	zombie = false
	
	altar_lifes = 0
	altar_gems = 0
	
	altar_level = 1
	
	Muted = true

func sustain():
	combo_time = 0.7

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

func play_sound(stream: AudioStream, options:= {}) -> AudioStreamPlayer:
	var audio_stream_player = AudioStreamPlayer.new()

	add_child(audio_stream_player)
	audio_stream_player.stream = stream
	
	for prop in options.keys():
		audio_stream_player.set(prop, options[prop])
	
	audio_stream_player.play()
	audio_stream_player.connect("finished", audio_stream_player, "queue_free")
	
	return audio_stream_player
