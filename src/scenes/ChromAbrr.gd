extends ColorRect
var amount_normal = 0.1
var distort_time = 0

func _ready():
	Global.distort_obj = self

func _physics_process(delta):
	if distort_time > 0:
		distort_time -= 1 * delta
		self.material.set_shader_param("amount", Global.pick_random([0.2, 0.3, 0.4, 0.5, 0.6]) * Global.pick_random([1, -1])) 
		if distort_time <= 0:
			distort_time = 0
			self.material.set_shader_param("amount", amount_normal)


func distort_all(n):
	distort_time = n 
