extends Node

var TOTAL_FLOORS = 7
var CURRENT_FLOOR = 1
var ENEMY_SPAWN_TIMER_TOTAL = 3
var ENEMY_SPAWN_TIMER = ENEMY_SPAWN_TIMER_TOTAL

var FLOOR_WAVES = [-1, 1, 1, 1, 1, 1, 1, 1] #TODO: Poner los valores correctos

func get_floor_waves():
	return FLOOR_WAVES[CURRENT_FLOOR]

func reset_spawn_timer():
	ENEMY_SPAWN_TIMER_TOTAL = ENEMY_SPAWN_TIMER_TOTAL # TODO: Recalcular
	ENEMY_SPAWN_TIMER = ENEMY_SPAWN_TIMER_TOTAL
	return ENEMY_SPAWN_TIMER
	
func next_floor():
	if CURRENT_FLOOR < TOTAL_FLOORS:
		CURRENT_FLOOR += 1

func _input(event):
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
