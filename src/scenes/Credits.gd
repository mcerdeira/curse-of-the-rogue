extends Node2D
var ttl = 2
var started = false

func _ready():	
	if !Global.Muted:
		music_init()
		
func _physics_process(delta):
	$CreditsNode.position.y -= 30 * delta
	
	if $CreditsNode.position.y <= -2200:
		Global.goto_title()
	
	if !started:
		ttl -= 1 * delta
		if ttl <= 0:
			if !$AnimationPlayer.is_playing():
				started = true
				$AnimationPlayer.play("New Anim")

func music_init():
	Music.play(Global.EndingTheme, 0.7)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "New Anim":
		$AnimationPlayer.play("New Anim_tiny")
	else:
		$AnimationPlayer.play("New Anim")
