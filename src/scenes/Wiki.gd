extends Node2D
var FULL_LIST = []

func activate_me():
	visible = true
	Global.normal_cursor()
	Global.LOGIC_PAUSE = true
	Global.play_sound(Global.AltarSfx)

func _ready():
	Global.WikiObj = self
	visible = false
	$item.animation = ""
	$lbl_title.text = ""
	$lbl_description.text = ""
	$lbl_long_description.text = ""
	
	FULL_LIST = [] + Global.PREMIUM_ITEMS + Global.ITEMS
	
	for item in FULL_LIST:
		var texture = $item.get_sprite_frames().get_frame(item.name, $item.get_frame())
		$items_list.add_item(item.description, texture)

func _on_items_list_item_selected(index):
	$item.animation = FULL_LIST[index].name
	$lbl_title.text = FULL_LIST[index].description
	$lbl_description.text = FULL_LIST[index].long_description
	$lbl_long_description.text = FULL_LIST[index].long_description2

func _on_btn_close_pressed():
	Global.custom_cursor()
	Global.LOGIC_PAUSE = false
	visible = false
