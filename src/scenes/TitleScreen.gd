extends Node2D
var wait_ttl = 1.4
var size_ttl = 0.5
var ui_canceled = false
var goup = false
var stop = false
var startgame = false
var start_ttl = 1.3
var ui_accept_action = false
var new_game_action = false
var continue_action = false
var options_visible = false

func _ready():
	$OptionsDialog.visible = false
	$lbl_build.text = "build " + Global.VERSION
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	$AnimationPlayer.play("Walking")
	$AnimationPlayer.playback_speed = 0.5
	
	if !Global.Muted:
		music_init()
		
	if !Global.saved_game:
		$PressStartContainer/btn_continue.disabled = true

func _physics_process(delta):
	if !options_visible:
		if startgame:
			start_ttl -= 1 * delta
			if start_ttl <= 0:
				get_tree().change_scene("res://scenes/Main.tscn")
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			return
		
		if stop and Input.is_action_just_pressed("ui_accept"):
			ui_accept_action = true
			if Global.saved_game: #Default es continue
				new_game_action = false
				continue_action = true
			else:
				new_game_action = true
				continue_action = false
				Global.delete_save()
			
		if !startgame and stop and ui_accept_action:
			if new_game_action:
				$PressStartContainer/btn_start.add_color_override("font_color", Color8(255, 255, 0, 255))
				$PressStartContainer/btn_quit.disabled = true
				$PressStartContainer/btn_continue.disabled = true
				$PressStartContainer/btn_options.disabled = true
			elif continue_action:
				$PressStartContainer/btn_continue.add_color_override("font_color", Color8(255, 255, 0, 255))
				$PressStartContainer/btn_quit.disabled = true
				$PressStartContainer/btn_start.disabled = true
				$PressStartContainer/btn_options.disabled = true
			
			Global.play_sound(Global.AcceptSfx)
			startgame = true
			return
			
		if !stop and !ui_canceled and Input.is_action_just_pressed("ui_accept"):
			ui_canceled = true
			$lbl_build.visible = true
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
	Global.MainThemePlaying = false
	Music.play(Global.TitleTheme, 0.7)

func get_to_place():
	$Sprite.play("default")
	$AnimationPlayer.stop()
	$Player/sprite.animation = "back"
	$Player/sprite.playing = false

func _on_AnimationPlayer_animation_finished(anim_name):
	get_to_place()

func _on_PressAnimation_animation_finished(anim_name):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.normal_cursor()

func _on_Sprite_animation_finished():
	$Sprite.playing = false
	$Sprite.frame = 0

func _on_btn_quit_pressed():
	if !options_visible:
		get_tree().quit()

func _on_btn_continue_pressed():
	if !options_visible:
		new_game_action = false
		continue_action = true
		ui_accept_action = true

func _on_btn_options_pressed():
	options_visible = true
	$OptionsDialog/chk_Music.pressed = !Global.Muted
	$OptionsDialog/chk_SFX.pressed = !Global.SfxMuted
	$OptionsDialog/chk_gamepad.pressed = Global.UseGamePad
	
	if !Global.GamepadsExists:
		$OptionsDialog/chk_gamepad.disabled = true
	
	$OptionsDialog.visible = true
	$PressStartContainer/btn_quit.disabled = true
	$PressStartContainer/btn_start.disabled = true
	$PressStartContainer/btn_continue.disabled = true

func _on_btn_start_pressed():
	if !options_visible:
		Global.delete_save()
		new_game_action = true
		continue_action = false
		ui_accept_action = true

func _on_btn_close_pressed():
	options_visible = false
	$OptionsDialog.visible = false
	$PressStartContainer/btn_quit.disabled = false
	$PressStartContainer/btn_start.disabled = false
	if Global.saved_game:
		$PressStartContainer/btn_continue.disabled = false
	Global.save_options()

func _on_chk_SFX_pressed():
	Global.SfxMuted = !$OptionsDialog/chk_SFX.pressed
	var music_idx = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(music_idx, Global.SfxMuted)

func _on_chk_Music_pressed():
	Global.Muted = !$OptionsDialog/chk_Music.pressed
	var music_idx = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(music_idx, Global.Muted)

func _on_chk_gamepad_pressed():
	Global.UseGamePad = $OptionsDialog/chk_gamepad.pressed
