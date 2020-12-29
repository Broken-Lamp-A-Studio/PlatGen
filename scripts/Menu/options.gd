extends TextureButton



func _process(delta):
	if(get_tree().get_root().get_node("Menu2/Camera2D/GUI/Mainmenu").visible == true):
		if(self.is_hovered()):
			get_node("text").texture = load("res://textures/default_buttons/options-2.png")
		else:
			get_node("text").texture = load("res://textures/default_buttons/options-1.png")
