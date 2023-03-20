extends Node2D
var FULL_LIST = []
var locked = "????????"

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
	
	FULL_LIST = [] + Global.ITEMS + Global.PREMIUM_ITEMS
	
	for item in FULL_LIST:
		if item.name in Global.UNLOCKED_ITEMS:
			var texture = $item.get_sprite_frames().get_frame(item.name, $item.get_frame())
			$items_list.add_item(item.description, texture)
		else:
			var texture = $item.get_sprite_frames().get_frame("unknown", 0)
			$items_list.add_item(locked, texture)


func _on_items_list_item_selected(index):
	var itm = $items_list.get_item_text(index)
	if itm == locked:
		$item.animation = "unknown"
		$lbl_title.text = "???????????????"
		$lbl_description.text = "???????????????"
		$lbl_long_description.text = "???????????????"
	else:
		$item.animation = FULL_LIST[index].name
		$lbl_title.text = FULL_LIST[index].description
		$lbl_description.text = FULL_LIST[index].long_description
		$lbl_long_description.text = FULL_LIST[index].long_description2

func _on_btn_close_pressed():
	Global.custom_cursor()
	Global.LOGIC_PAUSE = false
	visible = false
