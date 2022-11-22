extends Area2D

func _on_sprite_animation_finished():
	queue_free()
