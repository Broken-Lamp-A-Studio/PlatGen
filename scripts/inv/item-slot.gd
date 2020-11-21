extends Sprite

var item_name = ""
var amount = 0
func _ready():
	item_name = ""
	amount = 0
	texture = null
func set_item(texture2, amount2, item):
	
	item_name = item
	if not(texture2 == "nope"):
		texture = texture2
		var xt = texture.get_size().x
		var yt = texture.get_size().y
		if(xt > get_node("background").texture.get_size().x):
			texture.get_size().x = texture.get_size().x/get_node("background").texture.get_size().x
		if(yt > get_node("background").texture.get_size().y):
			texture.get_size().y = texture.get_size().y/get_node("background").texture.get_size().y
	amount += amount2
	if(amount <= 0):
		amount = 0
		texture = null
		item_name = ""
	return amount2
func mouse_use():
	if(self.visible):
		var mx = get_global_mouse_position().x
		var my = get_global_mouse_position().y
		var sx = position.x
		var sy = position.y
		var tx = get_node("background").texture.get_size().x
		var ty = get_node("background").texture.get_size().y
		if(mx > sx-tx/2 and mx < sx+tx/2 and my > sy-ty/2 and my < sy+ty/2):
			if(Input.is_mouse_button_pressed(BUTTON_LEFT)):
				if not(item_name == ""):
					if(get_tree().get_root().get_node("GAME/player/inv/mouse").item_name == "" or get_tree().get_root().get_node("GAME/player/inv/mouse").item_name == item_name):
						mouse_give(item_name, self.set_item("nope", round(-amount/2), item_name))
func mouse_give(item, amount):
	get_tree().get_root().get_node("GAME/player/inv/mouse").set_item(texture, amount, item)
