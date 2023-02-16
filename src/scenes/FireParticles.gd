extends Particles2D
var idols_chamber = null
var amount_base = 16
var pre_amount = 0

func _physics_process(delta):
	pass
#	if idols_chamber == null:
#		var ch = get_tree().get_nodes_in_group("idols_chamber")
#		if ch:
#			idols_chamber = ch[0]
#	else:
#		var dist = (global_position.distance_to(idols_chamber.global_position))
#		var calc_amount = dist / 16
#		print(round(calc_amount))
#		if round(pre_amount) != round(calc_amount):
#			amount = dist / 16
#			pre_amount = amount
