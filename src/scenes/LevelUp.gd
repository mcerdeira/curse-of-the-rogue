extends Node2D
var total_idols = 0

func _ready():
	z_index = VisualServer.CANVAS_ITEM_Z_MAX
	Global.LOGIC_PAUSE = false #TODO: esto va después de elegir la mejora
