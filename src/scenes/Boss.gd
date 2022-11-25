extends KinematicBody2D

#Boss type
var HEAD = ""
var BODY = ""
var WEAPON = ""

# Difficultu vars
var HEALTH = 10
var DAMAGE = 1
var ATTACK_RATE = 1
var IDLE_TIME = 0

func _physics_process(delta):
	process_head(delta)
	process_body(delta)
	process_weapon(delta)

func process_head(delta):
	pass

func process_body(delta):
	pass
	
func process_weapon(delta):
	pass
