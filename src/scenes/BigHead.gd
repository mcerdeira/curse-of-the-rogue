extends AnimatedSprite
var shaking = 0

func _ready():
	$area.add_to_group("big_head")
	visible = Global.FLOOR_TYPE == Global.floor_types.intro
	if !visible:
		queue_free()
		
func _physics_process(delta):
	if shaking > 0:
		shaking -= 1 * delta
		rotation_degrees = randi() % 2 * Global.pick_random([1, -1])
		if shaking <= 0:
			rotation_degrees = 0

func hit():
	Global.shaker_obj.shake(12, 0.4)
	Global.play_sound(Global.AltarSfx)
	shaking = 2
