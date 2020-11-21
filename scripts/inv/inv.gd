extends Node2D


func create_inv_and_show(name2, configuration):
	if not(get_node_or_null(name2)):
		var new_inv = Node2D.new()
		new_inv.name = name2
		self.add_child(new_inv)
		get_node(name2).visible = false
		var l = 0
		while not(l == configuration.size()):
			l += 1
			if(configuration[l].clear == true):
				new_inv.name = name2
				self.remove_child(new_inv)
				self.add_child(new_inv)
			#elif(configuration[l].obj == "addobj"):
			#	var ni1 = (configuration[l].type).new()
			#	ni1.name = configuration[l].name
			#	get_child(name2).add_child(ni1)
			#	get_node(name2+"/"+configuration[l].name).texture = load(configuration[l].texture)
			#	get_node(name2+"/"+configuration[l].name).position = configuration[l].pos
			#	get_node(name2+"/"+configuration[l].name).scale = configuration[l].scale
			elif(configuration[l].obj == "addscene"):
				var n = load(configuration[l].path)
				var ni2 = n.instance()
				ni2.name = configuration[l].name
				get_child(name2).add_child(ni2)
		get_node(name2).visible = true
	else:
		get_node(name2).visible = not(get_node(name2).visible)
	
func main_inv():
	if(Input.is_key_pressed(KEY_E)):
		create_inv_and_show("inv_mm", {{"clear":false}:{"obj":"addscene", "path":"", "name":"inv_mm"}})
func _process(delta):
	pass
