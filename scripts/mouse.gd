extends Sprite


func go_to_mouse():
	position.x = get_global_mouse_position().x
	position.y = get_global_mouse_position().y
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
func _process(delta):
	if(get_tree().get_root().get_node("Menu2/Camera2D/GUI/options/Mouse").active == true):
		go_to_mouse()
		self.visible = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		self.visible = false
