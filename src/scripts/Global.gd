extends Node
var arrow = preload("res://sprites/crosshair.png")
var gem_volume = -14
var kills = 0
var Seconds = 0
var Minutes = 0
var Hours = 0
var TimerOn = false
var KillerisMe = ""
var KillerisMeExtra = ""
var shaker_obj = null
var transition_obj = null
var SPAWNER = null
var LOGIC_PAUSE = false
var CURRENT_BOSS_NAME = ""
var FIRST = true
var TOTAL_FLOORS = 7
var CURRENT_FLOOR = 0
var ENEMY_SPAWN_TIMER_TOTAL = 10
var ENEMY_SPAWN_TIMER = ENEMY_SPAWN_TIMER_TOTAL
var poisoned_color = Color8(100, 196, 27)
var infected_color = Color8(203, 54, 220)
var froze_color = Color8(91, 173, 245)
var item_texture = preload("res://sprites/idol_item.png")

var FLOOR_TYPE = ""
var FLOOR_WAVES = [-1, 1, 2, 3, 3, 4, 4, 5]
var FLOOR_REWARD = [-1, 10, 15, 20, 25, 30, 35, 50]

var GAME_OVER = false
var FLOOR_OVER = false

#################################### Music & SFX #############################################
var MainTheme = null
var ShopAlterTheme = null
var MainThemePlaying = false
var Muted = false
var SfxMuted = false
var TitleTheme = null
var BossBattle = null

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
var AltarOpenedSfx = null
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

var max_combo = 1
var current_combo = 0
var combo_time = 0
var combo_time_total = 2.3

var has_backpack = false
var has_bleed = false
var has_idol_mask = false
var has_justice = false
var has_balloon = false
var flying = false
var masterkey = false
var life2win = false
var pay2win = false
var primary_weapon = ""
var secondary_weapon = ""
var automatic_weapon = []
var orbitals = []
var poison = false
var electric = false
var frozen = false
var temp_poison = false
var got_brain = false
var keys = 0
var melee_speed = 0.0
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
var shoot_speed_speed = 0.0
var rolling_ttl = 0
var dashing_ttl = 0

var altar_points = 0
var altar_lifes = 0
var altar_gems = 0
var altar_level = 0
var altar_level_max = 0
var magnet = false
var werewolf = false
var cherry = false

var POINTS_PER_LEVEL = [-1, 260, 563, 1228, 4595]

var werewolf_speed = 100
var werewolf_attack = 5

var one_shot_items = []

# Boss stuff
var mov_type_pong = {
	"name": "pong",
	"ttl": -1,
	"speed": 80,
	"stop_on_shoot": true,
	name3 = "King"
}
var mov_type_follow = {
	"name": "follow",
	"ttl": 5,
	"speed": 80,
	"stop_on_shoot": true,
	name3 = "Cursed"
}
var mov_type_random = {
	"name": "random",
	"ttl": 7,
	"speed": 90,
	"stop_on_shoot": true,
	name3 = "Blind"
}
var mov_type_horizontal = {
	"name": "horizontal",
	"ttl": -1,
	"speed": 150,
	"stop_on_shoot": false,
	name3 = "Queen"
}
var mov_type_none = {
	"name": "none",
	"ttl": -1,
	"speed": 0,
	"stop_on_shoot": false,
	name3 = "Prisoner"
}

var movement_types = [
	mov_type_pong,
	mov_type_follow,
	mov_type_random,
	mov_type_horizontal,
	mov_type_none
]

var att_type_charge = {
	name = "charge",
	count = 3, 
	ttl = 4,
	name3 = "Demon"
}
var att_type_cross = {
	name = "cross",
	count = -1,
	ttl = 5,
	name3 = "Pig"
}
var att_type_spin_x = {
	name = "spin_x",
	count = -1,
	ttl = 5,
	name3 = "Wolf"
}
var att_type_rain = {
	name = "rain",
	count = -1,
	ttl = 8,
	name3 = "Soul"
}
var att_type_melee = {
	name = "melee",
	count = 3,
	ttl = 3.7,
	name3 = "Knight"
}
var att_type_jump = {
	name = "jump",
	count = 1,
	ttl = 5.6,
	name3 = "Frog"
}

var attack_types = [
	att_type_charge,
	att_type_cross,
	att_type_spin_x,
	att_type_rain,
	att_type_melee,
	att_type_jump
]

var dmg_type_normal = {
	name = "normal",
	bullet = "fire_ball",
	name3 = "of Fire"
}
var dmg_type_poison = {
	name = "poison",
	bullet = "poison_ball",
	name3 = "of Venom"
}
var dmg_type_ice = {
	name = "ice",
	bullet = "ice_ball",
	name3 = "of Ice"
}

var damage_types = [
	dmg_type_normal,
	dmg_type_poison,
	dmg_type_ice
]

enum floor_types {
	intro,
	normal,
	boss,
	altar,
	shop,
	supershop,
	idols_chamber,
}

var grandpa_photo = {
	"name": "grandpa_photo",
	"description": "Grandpa's Photo!",
	"long_description": "I miss you, Grandpa",
	"price": 300,
	"type": "orbital",
	"oneshot": true,
}

var explosive_item = {
	"name": "explosive_item",
	"description": "Kaboom!",
	"long_description": "Explosive personality",
	"price": 300,
	"type": "active",
	"oneshot": true,
}

var pin_item = {
	"name": "pin_item",
	"description": "Pin",
	"long_description": "Bleed, mother******s",
	"price": 350,
	"type": "consumable",
	"oneshot": true,
}

var fly_item = {
	"name": "fly_item",
	"description": "Fly",
	"long_description": "Fly away from here...",
	"price": 500,
	"type": "consumable",
	"oneshot": true,
}

var justice = {
	"name": "justice",
	"description": "Justice",
	"long_description": "... and Justice for all...",
	"price": 380,
	"type": "consumable",
	"oneshot": true,
}

var idol_mask = {
	"name": "idol_mask",
	"description": "Mask of the Gods",
	"long_description": "Fear of the Mask",
	"price": 350,
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

var balloon = {
	"name": "balloon",
	"description": "Balloon",
	"long_description": "Zap! Zap!",
	"price": 120,
	"type": "pasive",
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

var plasma = {
	"name": "plasma",
	"description": "Plasma Balls",
	"long_description": "Science!!",
	"price": 300,
	"type": "gun",
	"oneshot": true,
}

var spells_book = {
	"name": "spells_book",
	"description": "Spells Book",
	"long_description": "Spooky",
	"price": 300,
	"type": "gun",
	"oneshot": true,
}

var power_glove = {
	"name": "power_glove",
	"description": "Gauntlet",
	"long_description": "I don't feel so good",
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

var backpack = {
	"name": "backpack",
	"description": "Backpack",
	"long_description": "Carry things!",
	"price": 550,
	"type": "item",
	"oneshot": true,
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
	"oneshot": true,
}

var speedup = {
	"name": "speedup",
	"description": "Speed boots",
	"long_description": "Speed Up",
	"price": 150,
	"type": "passive",
	"oneshot": true,
}

var meleeup = {
	"name": "meleeup",
	"description": "Chocolate Bar",
	"long_description": "Melee Speed Up",
	"price": 150,
	"type": "passive",
	"oneshot": true,
}

var ice_cream =  {
	"name": "ice_cream",
	"description": "Ice Cream",
	"long_description": "All Stats Up!",
	"price": 200,
	"type": "passive",
	"oneshot": true,
}

var damageup =  {
	"name": "damageup",
	"description": "Ramen Bowl",
	"long_description": "Damage Up",
	"price": 150,
	"type": "passive",
	"oneshot": true,
}

var blue_lobster = {
	"name": "blue_lobster",
	"description": "Blue Lobster",
	"long_description": "I'm Blue",
	"price": 200,
	"type": "passive",
	"oneshot": true,
}

var cherry_item = {
	"name": "cherry_item",
	"description": "Cherry",
	"long_description": "I'm seeing double",
	"price": 350,
	"type": "passive",
	"oneshot": true,
}

var luckup = {
	"name": "luckup",
	"description": "Clover",
	"long_description": "Luck Up",
	"price": 150,
	"type": "passive",
	"oneshot": true,
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

var key = {
	"name": "key",
	"description": "Key",
	"long_description": "A Key",
	"price": 150,
	"type": "consumable",
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

var ENEMY_BOSS_PATTERNS = [
	["skeleton"],
	["scorpion"],
	["bat"],
	["spider_xs"]
]

var IDOLS = [-1, 0, 0, 0, 0, 0, 0, 0]

var ENEMY_PATTERNS = [
	-1,
	[
		["tentacle"],
		["bloby"],
		["idol"],
		["scorpion", "scorpion", "scorpion"],
		["ghost"],
		["bat"],
		["dead_fire"],
		["scorpion"],
		["skeleton"],
		["spider"],
		["troll", "troll"]
	],
	[
		["scorpion", "scorpion", "scorpion", "scorpion"],
		["tentacle", "tentacle", "tentacle"],
		["scorpion", "scorpion", "scorpion", "bat"],
		["scorpion", "scorpion", "bat", "bat", "bloby"],
		["scorpion", "scorpion", "troll"],
		["spider", "spider"],
		["spider", "bat", "bat"],
		["spider", "idol", "bat"],
	],
	[
		["scorpion", "scorpion", "scorpion", "scorpion"],
		["idol", "idol", "idol", "tentacle", "tentacle"],
		["bat", "scorpion", "bat", "bat"],
		["bat", "bat", "troll", "troll"],
		["ghost", "ghost"],
		["spider", "bloby", "bloby"],
		["bloby", "bat", "bloby"],
		["idol", "idol", "idol"],
	],
	[	
		["dead_fire", "dead_fire", "dead_fire", "dead_fire", "dead_fire"],
		["dead_fire", "dead_fire", "dead_fire", "bloby", "bloby"],
		["skeleton", "skeleton", "skeleton", "bloby", "dead_fire"],
		["skeleton", "skeleton", "skeleton", "skeleton", "dead_fire"],
		["scorpion", "scorpion", "skeleton", "skeleton", "dead_fire"],
		["bat", "dead_fire", "dead_fire", "dead_fire", "dead_fire"],
		["dead_fire", "dead_fire", "troll", "troll", "troll"],
		["spider", "spider", "spider", "dead_fire", "dead_fire"],
		["idol", "idol", "idol", "bloby", "bloby"],
		["tentacle", "tentacle", "tentacle"],
		["bloby", "tentacle", "bloby"],
	],
	[
		["dead_fire", "dead_fire", "dead_fire", "dead_fire", "dead_fire"],
		["dead_fire", "dead_fire", "dead_fire", "bloby", "bloby"],
		["skeleton", "skeleton", "skeleton", "bloby", "dead_fire"],
		["skeleton", "skeleton", "skeleton", "skeleton", "dead_fire"],
		["scorpion", "scorpion", "skeleton", "skeleton", "dead_fire"],
		["bat", "dead_fire", "dead_fire", "dead_fire", "dead_fire"],
		["dead_fire", "dead_fire", "troll", "troll", "troll"],
		["spider", "spider", "spider", "dead_fire", "dead_fire"],
		["idol", "idol", "idol", "bloby", "bloby"],
		["bloby", "tentacle", "tentacle", "bloby"],
	],
	[
		["dead_fire", "dead_fire", "dead_fire", "dead_fire", "dead_fire"],
		["dead_fire", "dead_fire", "dead_fire", "bloby", "bloby"],
		["skeleton", "skeleton", "skeleton", "bloby", "dead_fire"],
		["skeleton", "skeleton", "skeleton", "skeleton", "dead_fire"],
		["scorpion", "scorpion", "skeleton", "skeleton", "dead_fire"],
		["bat", "dead_fire", "dead_fire", "dead_fire", "dead_fire"],
		["dead_fire", "dead_fire", "troll", "troll", "troll"],
		["spider", "spider", "spider", "dead_fire", "dead_fire"],
		["idol", "idol", "idol", "bloby", "bloby"],
		["idol", "tentacle", "tentacle", "bloby"],
	],
	[
		["dead_fire", "dead_fire", "dead_fire", "tentacle", "tentacle"],
		["dead_fire", "dead_fire", "dead_fire", "dead_fire", "dead_fire"],
		["dead_fire", "dead_fire", "dead_fire", "bloby", "bloby"],
		["skeleton", "skeleton", "skeleton", "bloby", "dead_fire"],
		["skeleton", "skeleton", "skeleton", "skeleton", "dead_fire"],
		["scorpion", "scorpion", "skeleton", "skeleton", "dead_fire"],
		["bat", "dead_fire", "dead_fire", "dead_fire", "dead_fire"],
		["dead_fire", "dead_fire", "troll", "troll", "troll"],
		["spider", "spider", "spider", "dead_fire", "dead_fire"],
		["idol", "idol", "idol", "bloby", "bloby"],
	],
]

func _data_overload():
	print(calc_points_level(1))
	print(calc_points_level(2))
	print(calc_points_level(3))
	print(calc_points_level(4))
	
	Muted = false
	SfxMuted = false
	load_game()
	for i in range(Global.IDOLS.size()):
		if Global.IDOLS[i] == 1:
			var texture = item_texture
			Global.one_shot_items.append(texture)
	
func restart_game():
	restart_pools()
	initialize()
	init_room()
	get_tree().reload_current_scene()
	
func boot_strap_game():
	restart_pools()
	custom_cursor()
	initialize()
	init_room()
	
func idol_acquired():
	Global.IDOLS[Global.CURRENT_FLOOR] = 1
	
func restart_pools():
	ITEMS = []
	PREMIUM_ITEMS = []
	
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
	PREMIUM_ITEMS.push_back(plasma)
	PREMIUM_ITEMS.push_back(explosive_item)
	PREMIUM_ITEMS.push_back(blue_lobster)
	PREMIUM_ITEMS.push_back(cherry_item)
	PREMIUM_ITEMS.push_back(balloon)
	PREMIUM_ITEMS.push_back(ice_cream)
	PREMIUM_ITEMS.push_back(justice)
	PREMIUM_ITEMS.push_back(spells_book)
	PREMIUM_ITEMS.push_back(power_glove)
	PREMIUM_ITEMS.push_back(idol_mask)
	PREMIUM_ITEMS.push_back(pin_item)
	PREMIUM_ITEMS.push_back(grandpa_photo)
	PREMIUM_ITEMS.push_back(backpack)
	
func _ready():
	LoadSfxAndMusic()
	boot_strap_game()
	
func set_visible_transition(val):
	transition_obj.visible = val
	
func pixelate(val):
	transition_obj.material.set_shader_param("factor", val)
	
func LoadSfxAndMusic():
	MainTheme = load("res://music/main_theme_option2.ogg")
	ShopAlterTheme = load("res://music/shop_altar_theme.mp3")
	TitleTheme = load("res://music/TitleTheme.ogg")
	BossBattle = load("res://music/BossBattle.wav")
	
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
	
	AltarOpenedSfx = WheelSfx
	
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
	
	SpikeBallSfx = load("res://sfx/SpikeBallSfx.wav")
	
	TrollSfx = GhostSfx
	TrollHitSfx = GhostHitSfx
	
	KatanaSfx = load("res://sfx/KatanaSfx.mp3")
	
func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_dict = {
		"altar_points" : altar_points,
		"altar_lifes" : altar_lifes,
		"altar_gems" : altar_gems,
		"altar_level" : altar_level,
		"IDOLS": Global.IDOLS,
	}
	save_game.store_line(to_json(save_dict))
	save_game.close()
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return 
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		altar_points = node_data.altar_points
		altar_lifes = node_data.altar_lifes
		altar_gems = node_data.altar_gems
		altar_level = node_data.altar_level
		Global.IDOLS = node_data.IDOLS

	save_game.close()
	
func init_timer():
	TimerOn = true
	Seconds = 0
	Minutes = 0
	Hours = 0
	
func start_kills():
	kills = 0
	
func start_timer():
	if !TimerOn:
		start_kills()
		TimerOn = true
	
func stop_timer():
	TimerOn = false
	
func timer_event(delta):
	if TimerOn:
		Seconds += 1 * delta
		if Seconds >= 60:
			Seconds = 0
			Minutes += 1
		
		if Minutes >= 60:
			Minutes = 0
			Hours += 1	
		
func custom_cursor():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.set_custom_mouse_cursor(arrow)
	
func normal_cursor():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.set_custom_mouse_cursor(null)
	
func altar_level_up():
	Global.play_sound(Global.AltarSfx)
	altar_points = 0
	altar_level += 1
	if altar_level > altar_level_max:
		altar_level = altar_level_max
	
func calc_points_level(_level:=-1):
	if _level == -1:
		_level = altar_level
		
	return POINTS_PER_LEVEL[_level]
	
func _physics_process(delta):
	timer_event(delta)
	
func enemy_by_boss():
	return Global.pick_random(ENEMY_BOSS_PATTERNS)
	
func get_boss_life():
	return 14.50 * CURRENT_FLOOR

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
	var rnd = pick_random([1, 3, 5, 7, 9, 11, 13, 15, 17])
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
		if PREMIUM_ITEMS.size() > 0 and (Global.FLOOR_TYPE == Global.floor_types.intro or Global.FLOOR_TYPE == Global.floor_types.altar):
			ITEM_POOL = [] + PREMIUM_ITEMS
		else:
			ITEM_POOL = [] + ITEMS
			if PREMIUM_ITEMS.size() > 0:
				if randi()%Global.bad_luck == 0:
					add_premiums(5)
			
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
	
	max_combo = 1
	current_combo = 0
	combo_time = 0
	combo_time_total = 2.3

	primary_weapon = "whip"
	secondary_weapon = "empty"
	automatic_weapon = []
	automatic_weapon.append("empty")
	
	orbitals = []
	
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
	melee_speed = 1
	
	shoot_speed_speed = 1.0
	shoot_speed_total = 5.0
	shoot_speed = 0.2
	
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
	kills = 0
	cherry = false
	has_balloon = false
	has_justice = false
	has_idol_mask = false
	has_bleed = false
	has_backpack = false
	
	_data_overload()

func sustain():
	if FLOOR_TYPE == floor_types.normal:
		combo_time = 0.7

func add_combo():
	if FLOOR_TYPE == floor_types.normal:
		combo_time = combo_time_total
		current_combo += 1
		if current_combo >= max_combo:
			max_combo = current_combo

func get_floor_waves():
	return FLOOR_WAVES[CURRENT_FLOOR]
	
func show_boss_name(boss_name):
	var HUD = get_tree().get_nodes_in_group("HUD")[0]
	HUD.show_boss_name(boss_name)
	
func update_boss_life(life, total_life):
	var HUD = get_tree().get_nodes_in_group("HUD")[0]
	HUD.update_boss_life(life, total_life)
	
func start_boss_batle():
	var HUD = get_tree().get_nodes_in_group("HUD")[0]
	HUD.start_boss_batle()
	
func hide_hud_extras(name):
	var HUD = get_tree().get_nodes_in_group("HUD")[0]
	HUD.hide_extras(name)
	
func add_extra_display(what, count):
	var HUD = get_tree().get_nodes_in_group("HUD")[0]
	HUD.add_extra_display(what, count)
	
func refresh_hud():
	var HUD = get_tree().get_nodes_in_group("HUD")[0]
	HUD.update_health()

func reset_spawn_timer():
	ENEMY_SPAWN_TIMER_TOTAL = ENEMY_SPAWN_TIMER_TOTAL # TODO: Recalcular
	ENEMY_SPAWN_TIMER = ENEMY_SPAWN_TIMER_TOTAL
	return ENEMY_SPAWN_TIMER
	
func next_floor(type):
	save_game()
	if type == "next":
		FLOOR_TYPE = floor_types.normal
		Global.FLOOR_OVER = false
		if CURRENT_FLOOR < TOTAL_FLOORS:
			CURRENT_FLOOR += 1
	elif type == "idols_chamber":
		FLOOR_TYPE = floor_types.idols_chamber
	elif type == "shop":
		FLOOR_TYPE = floor_types.shop
	elif type == "supershop":
		FLOOR_TYPE = floor_types.supershop
	elif type == "altar":
		FLOOR_TYPE = floor_types.altar
	elif type == "boss":
		FLOOR_TYPE = floor_types.boss
		
	Global.FLOOR_OVER = false
	Global.LOGIC_PAUSE = false
	get_tree().reload_current_scene()
	
func pay_price(_player, price_what, price_amount):
	if price_what == "life" and _player.inv_time > 0:
		return false
	
	if price_amount == 0:
		return true
		
	if price_what == "gems":
		if Global.gems >= price_amount:
			_player.add_gem_now(-price_amount)
			
			Global.add_extra_display("gems", -price_amount)
			yield(get_tree().create_timer(.5), "timeout") 
			Global.hide_hud_extras("gems")
			
			return true
	elif price_what == "life":
			if Global.zombie:
				return true
			else:
				_player.hit(price_amount, "bad_luck", true)
				return true
	elif price_what == "keys":
		if Global.keys >= price_amount or Global.masterkey:
			if !Global.masterkey:
				Global.keys -= price_amount
			
			return true

	return false
	
func _input(event):
	var cur_scene = get_tree().current_scene.name
	if cur_scene == "TitleScreen":
		if event.is_action_pressed("quit_game"):
			get_tree().quit()
	else:
		if event.is_action_pressed("toggle_fullscreen"):
			OS.window_fullscreen = !OS.window_fullscreen

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
