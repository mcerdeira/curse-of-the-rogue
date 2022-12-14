extends Node2D
var wait_ttl = 1.4
var size_ttl = 0.5
var ui_canceled = false
var goup = false
var stop = false
var startgame = false
var start_ttl = 1.3

var peppepe = 0
var pieulo = 0

func _ready():
	$AnimationPlayer.play("Walking")
	$AnimationPlayer.playback_speed = 0.5
	
	if !Global.Muted:
		music_init()

func _physics_process(delta):
	if startgame:
		start_ttl -= 1 * delta
		if start_ttl <= 0:
			get_tree().change_scene("res://scenes/Main.tscn")
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		return
	
	if !startgame and stop and Input.is_action_just_pressed("ui_accept"):
		Global.play_sound(Global.AcceptSfx)
		$Tilt.playback_speed = 4
		startgame = true
		return
		
	if !stop and !ui_canceled and Input.is_action_just_pressed("ui_accept"):
		ui_canceled = true
		$AnimationPlayer.seek(2)
		$Player/sprite.animation = "back"
		$Player/sprite.playing = true
		$Player/sprite.material.set_shader_param("blackened", true)
		wait_ttl = 0
		size_ttl = 0
		goup = true
		stop = true
		$Player.position.y = 518.949
		$Player/sprite.scale.x = 0.068498
		$Player/sprite.scale.y = $Player/sprite.scale.x
		$TitleAnimation.play("New Anim")
		$PressAnimation.play("New Anim")
	
	if $Player/sprite.animation == "back":
		if wait_ttl > 0:
			wait_ttl -= 1 * delta
		if wait_ttl <= 0:
			$Player/sprite.playing = true
			$Player/sprite.material.set_shader_param("blackened", true)
			if size_ttl > 0:
				size_ttl -= 1 * delta
			if size_ttl <= 0:
				if !goup:
					$Player.position.y += 10 * delta
					$Player/sprite.scale.x -= 0.05 * delta
					$Player/sprite.scale.y = $Player/sprite.scale.x
				else:
					if !stop and $Player.position.y <= 519:
						stop = true
						$TitleAnimation.play("New Anim")
						$PressAnimation.play("New Anim")
						
					if !stop:
						$Player.position.y -= 5 * delta
						$Player/sprite.scale.x -= 0.03 * delta
						$Player/sprite.scale.y = $Player/sprite.scale.x
				
				if !goup and $Player.position.y >= 615:
					goup = true
				
				if $Player/sprite.scale.x <= 0:
					$Player/sprite.scale.x = 0
					$Player/sprite.scale.y = 0

func music_init():
	Music.play(Global.TitleTheme, 0.7)

func get_to_place():
	$AnimationPlayer.stop()
	$Player/sprite.animation = "back"
	$Player/sprite.playing = false

func _on_AnimationPlayer_animation_finished(anim_name):
	get_to_place()

func _on_PressAnimation_animation_finished(anim_name):
	$Tilt.play("New Anim")
