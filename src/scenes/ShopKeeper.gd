extends KinematicBody2D
var texts = [
	"...",
	"AAAAAAAAAAAAAAAAHHHHHHHHHHHHHHHH",
	"ZZZ...ZZZ...ZZZ...ZZZ...ZZZ...",
	"Sometimes, I feel so lonely...",
	"I heard someone very brave came back from death",
	"Have you found happiness?",
	"How many floors there are?",
	"This place seems to be different everyday, but nobody believes me.",
	"I used to have a family... I think!",
	"Do I have a name? I can't remember..."
]

func _ready():
	if Global.FLOOR_TYPE != Global.floor_types.shop and Global.FLOOR_TYPE != Global.floor_types.supershop:
		queue_free()
	else:
		if Global.PREMIUM_ITEMS.size() > 0:
			var item = Global.pick_random(Global.PREMIUM_ITEMS)
			var line = "Did you heard about the " + item.description + "? I don't sell it, anyways!"
			texts.append(line)

		$dialog_text.text = Global.pick_random(texts)

func _physics_process(delta):
	z_index = position.y
	$dialog.rotation_degrees = randi() % 2 * Global.pick_random([1, -1])
