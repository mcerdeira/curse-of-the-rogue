extends Area2D


func _input_event(viewport, event, shape_idx):
	if event.type == InputEvent.MOUSE_BUTTON \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		print("Clicked")


func _on_dmg_area_input_event(viewport, event, shape_idx):
	if(event.is_pressed()):
		print("pressed!")
