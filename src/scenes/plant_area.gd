extends Area2D

func _ready():
	add_to_group("decorations")

func _destroy():
	get_parent()._destroy()
