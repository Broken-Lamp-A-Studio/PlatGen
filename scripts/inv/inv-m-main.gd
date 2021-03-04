extends Node2D

var node = ""
var count = 0
var in_use = false

func in_use2():
	if(count == 0):
		in_use = false
		self.visible = false
	elif(count != 0):
		get_node("texture").texture = load("res://textures/inv/txt/"+node+".png")
		get_node("Label").text = "%d"%count
	position = get_global_mouse_position()
func _process(_delta):
	in_use2()
