extends Node

var LOGIC_PAUSE = false
var FIRST = true
var TOTAL_FLOORS = 7
var CURRENT_FLOOR = 0
var ENEMY_SPAWN_TIMER_TOTAL = 10
var ENEMY_SPAWN_TIMER = ENEMY_SPAWN_TIMER_TOTAL

var FLOOR_TYPE = ""
var FLOOR_WAVES = [-1, 2, 2, 3, 3, 4, 4, 5]
var FLOOR_ROOMS = [-1, 2, 3, 4, 5, 6, 6, 7]
var FLOOR_REWARD = [-1, 10, 10, 20, 20, 30, 30, 50]
var FLOOR_ENEMIES = [
	-1,
	["scorpion", "bat"], 
	["scorpion", "bat", "skeleton"]
]

var GAME_OVER = false
var FLOOR_OVER = false

var max_combo = 0
var current_combo = 0
var combo_time = 0
var combo_time_total = 2.3

var primary_weapon = ""
var secondary_weapon = ""
var attack_rate = 0
var attack = 0
var speed = 0
var health_total = 0
var health = 0
var shield = 0
var gems = 0

enum floor_types {
	intro,
	normal,
	boss,
	altar,
	shop,
	supershop
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

func initialize():
	FIRST = true
	GAME_OVER = false
	FLOOR_OVER = false
	LOGIC_PAUSE = false
	FLOOR_TYPE = ""
	
	max_combo = 0
	current_combo = 0
	combo_time = 0
	combo_time_total = 2.3

	primary_weapon = ""
	secondary_weapon = ""
	attack_rate = 0
	attack = 0
	speed = 0
	health_total = 0
	health = 0
	shield = 0
	gems = 0

func sustain():
	combo_time = 0.5

func add_combo():
	combo_time = combo_time_total
	current_combo += 1
	if current_combo > max_combo:
		max_combo = current_combo

func get_floor_waves():
	return FLOOR_WAVES[CURRENT_FLOOR]

func reset_spawn_timer():
	ENEMY_SPAWN_TIMER_TOTAL = ENEMY_SPAWN_TIMER_TOTAL # TODO: Recalcular
	ENEMY_SPAWN_TIMER = ENEMY_SPAWN_TIMER_TOTAL
	return ENEMY_SPAWN_TIMER
	
func next_floor(type):
	if type == "next":
		FLOOR_TYPE = floor_types.normal
		if CURRENT_FLOOR < TOTAL_FLOORS:
			CURRENT_FLOOR += 1
	elif type == "shop":
		FLOOR_TYPE = floor_types.shop
	elif type == "supershop":
		FLOOR_TYPE = floor_types.supershop
	elif type == "altar":
		FLOOR_TYPE = floor_types.altar
		
	Global.LOGIC_PAUSE = false
	get_tree().reload_current_scene()
	

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
