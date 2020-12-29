class Shell:
	extends Node
	func wait(time):
		var t = OS.get_system_time_msecs()
		while not(OS.get_system_time_msecs() - t > time):
			pass
	func move(steps, posx, posy, rotation_d):
		var position = {x=(posx+sin(rotation_d)*steps), y=(posy+cos(rotation_d)*steps)}
		return position
	func make_instance(path, type, name2, script):
		var item_instance = type.new()
		if not(script == null):
			var script2 = Script.new()
			script2.source_code = load(script)
			item_instance.set_script(script2)
		item_instance.name = name2
		get_tree().get_root().get_node(path).add_child(item_instance)
