extends Node2D
var speed = 10
onready var enemy_bullets = [$EnemyBullet, $EnemyBullet2, $EnemyBullet3, $EnemyBullet4]
var from = ""

func _physics_process(delta):
	rotation_degrees += 200 * delta
	
	for b in enemy_bullets:
		b.rotation_degrees = -rotation_degrees
		b.from = from
