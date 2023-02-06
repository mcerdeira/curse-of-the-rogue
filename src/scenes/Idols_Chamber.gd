extends Area2D
var got_idols = false
var animations_created = false
var IdolAnimation = preload("res://scenes/IdolAnimation.tscn")

func _ready():
	if Global.FLOOR_TYPE != Global.floor_types.idols_chamber:
		queue_free()
		return
	else:
		eval_idols()

func eval_idols():
	if Global.IDOLS[7] == 2:
		$AltarProgressDecoration.playing = true
	
	for i in range(Global.IDOLS.size()):
		if Global.IDOLS[i] == 1:
			got_idols = true
			
		if Global.IDOLS[i] == 2:
			var slot = get_node("IdolSlot" + str(i))
			slot.activate_idol()
			
func create_animations(body):
	var idol = null
	animations_created = true
	for i in range(Global.IDOLS.size()):
		if Global.IDOLS[i] == 1:
			idol = IdolAnimation.instance()
			var root = get_node("/root/Main")
			root.add_child(idol)
			idol.global_position = body.global_position
			idol.delay = 0.7 * i
			var num = i
			idol.num = num
			idol.Chamber = self
	
	idol.last = true
	
func _on_Idols_Chamber_body_entered(body):
	if !animations_created and got_idols and body.is_in_group("players"):
		Global.play_sound(Global.LevelEndSfx)
		Global.LOGIC_PAUSE = true
		$AltarProgressDecoration.playing = true
		create_animations(body)
