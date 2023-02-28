extends Area2D
var got_idols = false
var animations_created = false
var IdolAnimation = preload("res://scenes/IdolAnimation.tscn")
var total_idols = 0

func _ready():
	add_to_group("idols_chamber")
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
			total_idols += 1
			got_idols = true
			
		if Global.IDOLS[i] == 2:
			if range(Global.IDOL_PERKS.size()).has(i-1):
				var slot = get_node("IdolSlot" + str(i))
				slot.activate_idol(Global.IDOL_PERKS[i-1])
			
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
			idol.total_idols = total_idols
			idol.Chamber = self
	
	idol.last = true
	
func _on_Idols_Chamber_body_entered(body):
	if !animations_created and got_idols and body.is_in_group("players"):
		Global.play_sound(Global.LevelEndSfx)
		Global.LOGIC_PAUSE = true
		Global.GETTING_PERKS = true
		$AltarProgressDecoration.playing = true
		create_animations(body)
