extends Node2D
var type = ""
var effect_name = ""

func _ready():
	$lander.add_to_group("lander")
	$EnemyBullet.type = type
	$EnemyBullet.effect_name = effect_name
	$EnemyBullet.init_again()
