extends Node2D

var item_count = 0
var node = ""

func item_inv():
	if(self.visible == true and get_tree().get_root().get_node("GAME/inv/main").in_use != true):
		var mx = get_local_mouse_position().x
		var my = get_local_mouse_position().y
		if(mx > (self.position.x-25) and mx < self.position.x+25 and my > (self.position.y-25) and my < self.position.y+25):
			if(Input.is_mouse_button_pressed(KEY_LEFT)):
				take_item_to_mouse(item_count)
			if(Input.is_mouse_button_pressed(KEY_RIGHT)):
				take_item_to_mouse(round(item_count/2))
func take_item_to_mouse(count):
	item_count -= count
	if(item_count == 0):
		get_node("item_texture").visible = false
	else:
		get_node("item_texture").visible = true
	get_tree().get_root().get_node("GAME/inv/main").node = node
	get_tree().get_root().get_node("GAME/inv/main").count = count
func give_item(item, count):
	if(item == node):
		item_count += count
		return "yes"
	else:
		return "nope"
	if(item_count == 0):
		get_node("item_texture").texture == load("res://textures/inv/txt/"+item+".png")
		node = item
		item_count = count
		return "yes"
func _process(delta):
	item_inv()
