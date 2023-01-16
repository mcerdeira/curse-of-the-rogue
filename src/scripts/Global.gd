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
var froze_color = Color8(91, 173, 245)

var FLOOR_TYPE = ""
var FLOOR_WAVES = [-1, 1, 1, 3, 3, 4, 4, 5]
var FLOOR_REWARD = [-1, 10, 10, 20, 20, 30, 30, 50]

var GAME_OVER = false
var FLOOR_OVER = false

#################################### Music & SFX #############################################
var MainTheme = null
var ShopAlterTheme = null
var MainThemePlaying = false
var Muted = false
var SfxMuted = false
var TitleTheme = null

var FallingSfx = null
var AcceptSfx = null
var GemSfx = null
var MasterKeySfx = null
var KeySfx = null
var ItemSfx = null
var LifeSfx = null
var WeaponSfx = null
var PlayerHurt = null
var WereWolfSfx = null
var ZombieSfx = null
var PlayerDieSfx = null
var PlayerEnteringSfx = null
var PlasmaSfx = null
var ShotGunSfx = null
var KnifeSfx = null
var BombSxf = null
var BombExplosionSfx = null
var TomaHawkSfx = null
var WhipSfx = null
var AltarSfx = null
var PropsSfx = null
var WheelMoveSfx = null
var WheelSfx = null
var ChestOpenSfx = null
var ChestAnimationSfx = null
var LevelEndSfx = null
var MegaRaySfx = null
var GhostShootSfx = null
var DeadFireShootSfx = null
var SkeleShootSfx = null
var BatsSfx = null
var DeadFireSfx = null
var GhostSfx = null
var ScorpionSfx = null
var SkeleSfx = null
var GhostHitSfx = null
var DeadFireHitSfx = null
var BatsHitSfx
var ScorpionHitSfx = null
var SkeleHitSfx = null
var ElectricSfx = null
var FrozeSfx = null
var PoisonSfx = null
var SpiderSfx = null
var SpiderHitSfx = null
var SpikeBallSfx = null
var TrollSfx = null
var TrollHitSfx = null
var KatanaSfx = null

############################################################################

var max_combo = 0
var current_combo = 0
var combo_time = 0
var combo_time_total = 2.3

var flying = false
var masterkey = false
var life2win = false
var pay2win = false
var primary_weapon = ""
var secondary_weapon = ""
var automatic_weapon = ""
var poison = false
var electric = false
var frozen = false
var temp_poison = false
var got_brain = false
var keys = 0
var melee_rate = 0.0
var melee_rate_total = 0.0
var attack = 0
var roll_speed = 0
var dash_speed = 0
var attack_max = 0
var speed = 0
var water_speed = 0
var health = []
var shield = 0
var gems = 0
var bad_luck = 0
var total_bad_luck = 0
var zombie = false
var shoot_speed = 0.0
var shoot_speed_total = 0.0
var rolling_ttl = 0
var dashing_ttl = 0

var altar_points = 0
var altar_lifes = 0
var altar_gems = 0
var altar_level = 0
var altar_level_max = 0
var magnet = false
var werewolf = false

var POINTS_BASE = 9
var POINTS_X = 1
var POINTS_Y = 3

var werewolf_speed = 100
var werewolf_attack = 5

var one_shot_items = []

enum floor_types {
	intro,
	normal,
	boss,
	altar,
	shop,
	supershop
}

var fly_item = {
	"name": "fly_item",
	"description": "Fly",
	"long_description": "Fly away from here...",
	"price": 500,
	"type": "consumable",
	"oneshot": true,
}

var magnet_item = {
	"name": "magnet",
	"description": "Magnet",
	"long_description": "Attraction!",
	"price": 350,
	"type": "consumable",
	"oneshot": true,
}

var master_key = {
	"name": "master_key",
	"description": "Master Key",
	"long_description": "One Key to rule em all",
	"price": 450,
	"type": "consumable",
	"oneshot": true,
}

var pay_2_win = {
	"name": "pay_2_win",
	"description": "Pay 2 Win",
	"long_description": "Attack depends on Gems",
	"price": 550,
	"type": "active",
	"oneshot": true,
}

var life_2_win = {
	"name": "life_2_win",
	"description": "Life 2 Win",
	"long_description": "Attack depends on Life",
	"price": 550,
	"type": "active",
	"oneshot": true,
}

var electric_attack = {
	"name": "electric_attack",
	"description": "Electrifying",
	"long_description": "Electric attack",
	"price": 450,
	"type": "active",
	"oneshot": true,
}

var ice_attack = {
	"name": "ice_attack",
	"description": "Ice Touch",
	"long_description": "Froze em' all",
	"price": 450,
	"type": "active",
	"oneshot": true,
}

var dash_item = {
	"name": "dash",
	"description": "Dash",
	"long_description": "Be quick or be death",
	"price": 300,
	"type": "active",
	"oneshot": true,
}

var roll_item = {
	"name": "roll",
	"description": "Cinamon Roll",
	"long_description": "Keep rolling, rolling...",
	"price": 300,
	"type": "active",
	"oneshot": true,
}

var shot_gun = {
	"name": "shot_gun",
	"description": "Shotgun",
	"long_description": "Spread of bullets",
	"price": 300,
	"type": "gun",
	"oneshot": true,
}

var spikeball = {
	"name": "spikeball",
	"description": "Spike-Balls",
	"long_description": "I got balls of steel",
	"price": 300,
	"type": "gun",
	"oneshot": true,
}

var katana = {
	"name": "katana",
	"description": "Katana",
	"long_description": "Mighty Blade",
	"price": 400,
	"type": "gun",
	"oneshot": true,
}

var knife = {
	"name": "knife",
	"description": "Knife",
	"long_description": "Piercing Knife",
	"price": 300,
	"type": "gun",
	"oneshot": true,
}

var bomb = {
	"name": "bomb",
	"description": "Bomb",
	"long_description": "Ka-Boom!",
	"price": 300,
	"type": "gun",
	"oneshot": true,
}

var tomahawk = {
	"name": "tomahawk",
	"description": "Tomahawk",
	"long_description": "You can't eat it",
	"price": 300,
	"type": "gun",
	"oneshot": true,
}

var key = {
	"name": "key",
	"description": "Key",
	"long_description": "A Key",
	"price": 150,
	"type": "consumable",
	"oneshot": false,
}
	
var wolfe_bite =  {
	"name": "wolfe_bite",
	"description": "Wolf Bite",
	"long_description": "A wolf bite",
	"price": 350,
	"type": "modifier",
	"oneshot": true,
}

var brain =  {
	"name": "brain",
	"description": "Brain",
	"long_description": "Yummy for zombies",
	"price": 350,
	"type": "modifier",
	"oneshot": true,
}

var poison_itm =  {
	"name": "poison",
	"description": "Poison Drop",
	"long_description": "Poisonous touch",
	"price": 250,
	"type": "passive",
	"oneshot": true,
}

var shoot_speed_up = {
	"name": "shoot_speed_up",
	"description": "Adrenaline",
	"long_description": "Shoot Speed Up",
	"price": 200,
	"type": "passive",
	"oneshot": false,
}

var speedup = {
	"name": "speedup",
	"description": "Speed boots",
	"long_description": "Speed Up",
	"price": 150,
	"type": "passive",
	"oneshot": false,
}

var meleeup = {
	"name": "meleeup",
	"description": "Chocolate Bar",
	"long_description": "Melee Speed Up",
	"price": 150,
	"type": "passive",
	"oneshot": false,
}

var damageup =  {
	"name": "damageup",
	"description": "Ramen Bowl",
	"long_description": "Damage Up",
	"price": 150,
	"type": "passive",
	"oneshot": false,
}

var luckup = {
	"name": "luckup",
	"description": "Clover",
	"long_description": "Luck Up",
	"price": 150,
	"type": "passive",
	"oneshot": false,
}

var blue_heart = {
	"name": "blue_heart",
	"description": "Blue Heart",
	"long_description": "Shield",
	"price": 50,
	"type": "item",
	"oneshot": false,
}

var green_heart =  {
	"name": "green_heart",
	"description": "Green Heart",
	"long_description": "Shield + Poison",
	"price": 75,
	"type": "item",
	"oneshot": false,
}

var empty_heart =  {
	"name": "empty_heart",
	"description": "Empty Heart",
	"long_description": "Heart Container",
	"price": 150,
	"type": "item",
	"oneshot": false,
}

var normal_heart = {
	"name": "normal_heart",
	"description": "Heart",
	"long_description": "Fills a Heart",
	"price": 25,
	"type": "item",
	"oneshot": false,
}

var ITEMS = []
var PREMIUM_ITEMS = []
var ITEM_POOL = []

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
		["spider"],
		["troll", "troll", "troll"]
	],
	[
		["scorpion", "scorpion", "scorpion", "scorpion"],
		["scorpion", "scorpion", "scorpion", "bat"],
		["scorpion", "scorpion", "bat", "bat"],
		["scorpion", "scorpion", "troll"],
		["spider", "spider"],
		["spider", "spider", "bat", "bat"],
	],
	[
		["scorpion", "scorpion", "scorpion", "scorpion"],
		["bat", "scorpion", "bat", "bat"],
		["bat", "bat", "troll", "troll"],
		["ghost", "ghost"],
		["spider", "spider", "spider"],
	],
	[	
		["dead_fire", "dead_fire", "dead_fire", "dead_fire", "dead_fire"],
		["skeleton", "skeleton", "skeleton", "skeleton", "dead_fire"],
		["scorpion", "scorpion", "skeleton", "skeleton", "dead_fire"],
		["bat", "dead_fire", "dead_fire", "dead_fire", "dead_fire"],
		["dead_fire", "dead_fire", "troll", "troll", "troll"],
		["spider", "spider", "spider", "dead_fire", "dead_fire"],
	],
	[
		["ghost", "ghost", "troll"],
		["troll", "dead_fire", "dead_fire", "ghost", "ghost", "ghost"],
		["skeleton", "skeleton", "skeleton", "skeleton", "ghost"],
		["ghost", "scorpion", "scorpion", "scorpion", "scorpion", "scorpion"],
		["spider", "spider", "scorpion", "scorpion", "skeleton", "skeleton"],
	],
	[],
]

func _data_overload():
	Muted = false
	SfxMuted = false

func _ready():
	ITEMS.push_back(blue_heart)
	ITEMS.push_back(green_heart)
	ITEMS.push_back(empty_heart)
	ITEMS.push_back(normal_heart)
	ITEMS.push_back(key)
	
	PREMIUM_ITEMS.push_back(luckup)
	PREMIUM_ITEMS.push_back(damageup)
	PREMIUM_ITEMS.push_back(meleeup)
	PREMIUM_ITEMS.push_back(speedup)
	PREMIUM_ITEMS.push_back(shoot_speed_up)
	PREMIUM_ITEMS.push_back(poison_itm)
	PREMIUM_ITEMS.push_back(brain)
	PREMIUM_ITEMS.push_back(wolfe_bite)
	PREMIUM_ITEMS.push_back(shot_gun)
	PREMIUM_ITEMS.push_back(knife)
	PREMIUM_ITEMS.push_back(bomb)
	PREMIUM_ITEMS.push_back(tomahawk)
	PREMIUM_ITEMS.push_back(electric_attack)
	PREMIUM_ITEMS.push_back(ice_attack)
	PREMIUM_ITEMS.push_back(pay_2_win)
	PREMIUM_ITEMS.push_back(life_2_win)
	PREMIUM_ITEMS.push_back(master_key)
	PREMIUM_ITEMS.push_back(magnet_item)
	PREMIUM_ITEMS.push_back(dash_item)
	PREMIUM_ITEMS.push_back(roll_item)
	PREMIUM_ITEMS.push_back(fly_item)
	PREMIUM_ITEMS.push_back(spikeball)
	PREMIUM_ITEMS.push_back(katana)
	
	LoadSfxAndMusic()
	
	custom_cursor()
	initialize()
	init_room()
	
func LoadSfxAndMusic():
	MainTheme = load("res://music/main_theme_option2.ogg")
	ShopAlterTheme = load("res://music/shop_altar_theme.mp3")
	TitleTheme = load("res://music/TitleTheme.ogg")
	
	FallingSfx = load("res://sfx/FallingSfx.wav")
	AcceptSfx = load("res://sfx/Accept.mp3")
	GemSfx = load("res://sfx/GemSfx.wav")
	MasterKeySfx = load("res://sfx/MasterKeySfx.ogg")
	KeySfx = load("res://sfx/KeySfx.ogg")
	ItemSfx = load("res://sfx/ItemSfx.wav")
	LifeSfx = load("res://sfx/LifeSfx.wav")
	WeaponSfx = load("res://sfx/WeaponSfx.ogg")
	PlayerHurt = load("res://sfx/PlayerHurt.wav")
	WereWolfSfx = load("res://sfx/WereWolfSfx.wav")
	ZombieSfx = load("res://sfx/ZombieSfx.ogg")
	PlayerDieSfx = load("res://sfx/PlayerDieSfx.wav")
	PlayerEnteringSfx = load("res://sfx/PlayerEnteringSfx.wav")
	PlasmaSfx = load("res://sfx/PlasmaSfx.ogg")
	ShotGunSfx = load("res://sfx/ShotGunSfx.ogg")
	KnifeSfx = load("res://sfx/KnifeSfx.wav")
	BombSxf = load("res://sfx/BombSxf.wav")
	BombExplosionSfx = load("res://sfx/BombExplosionSfx.wav")
	TomaHawkSfx = load("res://sfx/TomaHawkSfx.wav")
	WhipSfx = load("res://sfx/WhipSfx.wav")
	AltarSfx = load("res://sfx/AltarSfx.wav")
	PropsSfx = load("res://sfx/PropsSfx.wav")
	WheelMoveSfx = load("res://sfx/WheelMoveSfx.wav")
	WheelSfx = load("res://sfx/WheelSfx.wav")
	ChestOpenSfx = load("res://sfx/ChestOpenSfx.ogg")
	ChestAnimationSfx = load("res://sfx/ChestAnimationSfx.wav")
	LevelEndSfx = load("res://sfx/LevelEndSfx.wav")
	#MegaRaySfx = load("res://sfx/file.wav")
	
	DeadFireSfx = load("res://sfx/DeadFireSfx.wav")
	DeadFireHitSfx = load("res://sfx/DeadFireHitSfx.wav")
	DeadFireShootSfx = DeadFireSfx
	
	SkeleSfx = load("res://sfx/SkeleSfx.wav")
	SkeleHitSfx = load("res://sfx/SkeleHitSfx.wav")
	SkeleShootSfx = SkeleSfx
	
	BatsSfx = load("res://sfx/BatsSfx.ogg")
	BatsHitSfx = load("res://sfx/BatsHitSfx.ogg")
	
	ScorpionSfx = load("res://sfx/ScorpionSfx.wav")
	ScorpionHitSfx = load("res://sfx/ScorpionHitSfx.wav")
	
	GhostSfx = load("res://sfx/GhostSfx.wav")
	GhostHitSfx = load("res://sfx/GhostHitSfx.wav")
	GhostShootSfx = GhostSfx
	
	ElectricSfx = load("res://sfx/ElectricSfx.wav")
	FrozeSfx = load("res://sfx/FrozeSfx.wav")
	PoisonSfx = load("res://sfx/PoisonSfx.wav")
	
	SpiderSfx = ScorpionSfx
	SpiderHitSfx = ScorpionHitSfx
	
	SpikeBallSfx = null
	
	TrollSfx = null
	TrollHitSfx = null
	
	KatanaSfx = WhipSfx
	
func custom_cursor():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.set_custom_mouse_cursor(arrow)
	
func normal_cursor():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.set_custom_mouse_cursor(null)
	
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
		
func add_normals(n):
	var norm_copy = [] + ITEMS
	for i in range(n):
		var idx = -1
		if norm_copy.size() > 0:
			idx = randi() % norm_copy.size()
			var itm = norm_copy.pop_at(idx)
			ITEM_POOL.append(itm)
		else:
			break
	
func add_premiums(n ):
	var prem_copy = [] + PREMIUM_ITEMS
	for i in range(n):
		var idx = -1
		if prem_copy.size() > 0:
			idx = randi() % prem_copy.size()
			var itm = prem_copy.pop_at(idx)
			ITEM_POOL.append(itm)
		else:
			break
		
func init_pool(only_normal_items:= false):
	randomize()
	ITEM_POOL = []
	if only_normal_items:
		ITEM_POOL = [] + ITEMS
	else:
		if PREMIUM_ITEMS.size() > 0 and Global.FLOOR_TYPE == Global.floor_types.altar:
			ITEM_POOL = [] + PREMIUM_ITEMS
			if randi()%Global.bad_luck != 0:
				add_normals(5)
		else:
			ITEM_POOL = [] + ITEMS
			if PREMIUM_ITEMS.size() > 0:
				if randi()%Global.bad_luck == 0:
					add_premiums(2)
			
func remove_from_pool(_name):
	for i in range(PREMIUM_ITEMS.size() - 1):
		if PREMIUM_ITEMS[i].name == _name:
			PREMIUM_ITEMS.remove(i)
	
func get_random_item(force:=false):
	randomize()
	if force:
		init_pool(true)
	else:
		if ITEM_POOL.size() == 0:
			init_pool()
		
	var idx = -1
	idx = randi() % ITEM_POOL.size()
	var itm = ITEM_POOL.pop_at(idx)
	return itm

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
	
	dash_speed = 500
	dashing_ttl = 0.3
	
	roll_speed = 200
	rolling_ttl = 0.6
	
	water_speed = 140.00
	speed = 150.00
	total_bad_luck = 100
	bad_luck = total_bad_luck
	attack = 1
	attack_max = 20

	keys = 0
	shield = 0
	health = [1, 1, 1]

	melee_rate_total = 1.0
	melee_rate = 0
	
	shoot_speed_total = 5.0
	shoot_speed = 0
	
	gems = 0
	
	poison = false
	electric = false
	frozen = false
	
	temp_poison = false
	zombie = false
	
	altar_lifes = 0
	altar_gems = 0
	
	altar_level = 1
	altar_level_max = 4
	
	health = [1, 1, 1]
	
	one_shot_items = []
	
	pay2win = false
	life2win = false
	masterkey = false
	magnet = false
	werewolf = false
	got_brain = false
	flying = false
	
	_data_overload()

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
		if Global.keys >= price_amount or Global.masterkey:
			if !Global.masterkey:
				Global.keys -= price_amount
			
			return true

	return false
	
func restart_game():
	initialize()
	init_room()
	get_tree().reload_current_scene()
	
func _input(event):
	var cur_scene = get_tree().current_scene.name
	if cur_scene == "TitleScreen":
		if event.is_action_pressed("quit_game"):
			get_tree().quit()
	else:
		if event.is_action_pressed("toggle_fullscreen"):
			OS.window_fullscreen = !OS.window_fullscreen
		if event.is_action_pressed("restart_game"):
			restart_game()

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
	if SfxMuted:
		return null
	else:
		var audio_stream_player = AudioStreamPlayer.new()

		add_child(audio_stream_player)
		audio_stream_player.stream = stream
		
		for prop in options.keys():
			audio_stream_player.set(prop, options[prop])
		
		audio_stream_player.play()
		audio_stream_player.connect("finished", audio_stream_player, "queue_free")
		
		return audio_stream_player
