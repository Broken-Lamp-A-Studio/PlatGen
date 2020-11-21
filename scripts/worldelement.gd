extends StaticBody2D

var node = ""
var gui = false
var node_data = {}
onready var replace_self_time = OS.get_system_time_secs()
var game_path = ""
var chunk_name = ""
func _ready():
	self.visible = true
	set_process(true)
func gui_move():
	if(gui != false):
		get_node(gui).position.x = get_viewport_rect().size.x/2
		get_node(gui).position.y = get_viewport_rect().size.y/2
func object_scale():
	if(get_node("texture").texture):
		var scal2 = get_node("texture").texture.get_size()
		get_node("CollisionShape2D").shape.extents.x = scal2.x/2
		get_node("CollisionShape2D").shape.extents.y = scal2.y/2
		get_node("LightOccluder2D").scale.x = scal2.x/2
		get_node("LightOccluder2D").scale.y = scal2.y/2
func setup(name2, node2, texture2, gui2, effects2, collision, light, x2, y2):
	position.x = x2
	position.y = y2
	var dir = Directory.new()
	if(dir.file_exists(game_path+"/blocks/%d"%position.x+"%d"%position.y+".node")):
		load_node()
		print("loading node!")
	else:
		print("making node!")
	#if(1 == 1):
		node_data = {
			"name2":name2,
			"node2":node2,
			"texture2":texture2,
			"gui2":gui2,
			"effects2":effects2,
			"collision":collision,
			"light":light,
			"x2":x2,
			"y2":y2
		}
		save_node()

	if(node2 != null or node2 != false or node2 != ""):
		node = node_data.node2
	else:
		print("ERROR: Node doesn't have name!")

	var px2 = get_tree().get_root().get_node("GAME/player").position.x
	var py2 = get_tree().get_root().get_node("GAME/player").position.y
	if(node_data.x2 < px2+200 and node_data.x2 > px2-200 and node_data.y2 < py2+200 and node_data.y2 > py2-200):
		node_data.name2 = "air"
		node_data.texture2 = ""
		node_data.collision = false
		name2 = "air"
		get_node("texture").texture = null
		get_node("CollisionShape2D").disabled = true
	if(dir.file_exists(node_data.texture2)):
		get_node("texture").texture = load(node_data.texture2)
	else:
		get_node("texture").visible = false
	if(node_data.collision):
		get_node("CollisionShape2D").disabled = true
	else:
		get_node("CollisionShape2D").disabled = false
	object_scale()
	if(node_data.node2 == "air" or node_data.texture2 == ""):
		get_node("CollisionShape2D").disabled = true
	else:
		get_node("CollisionShape2D").disabled = false
func visible2():
	var range_x = self.position.x+get_viewport_rect().size.x/2+50*5
	var range_y = self.position.y+get_viewport_rect().size.y/2+50*5
	var x = get_tree().get_root().get_node("GAME/player").position.x
	var y = get_tree().get_root().get_node("GAME/player").position.y
	if not(y < range_y and y > range_y-(get_viewport_rect().size.y/2+50*5)*2 and x < range_x and x > range_x-(get_viewport_rect().size.x/2+50*5)*2):
		save_node()
		self.queue_free()
func _process(delta):
	visible2()
	gui_move()
	interact_in_block()
	
		
	replace_self("near", 0, -50, "air", "dirt_with_grass", "dirt", 5)
func replace_self(type, nodeposx, nodeposy, input, input2, output, waittime):
	if(type == "near"):
		if(get_tree().get_root().get_node_or_null("GAME/world/%d"%(self.position.x+nodeposx)+"%d"%(self.position.y+nodeposy)) and node == input2):
			if(get_tree().get_root().get_node_or_null("GAME/world/%d"%(self.position.x+nodeposx)+"%d"%(self.position.y+nodeposy)).node != input):
				if(OS.get_system_time_secs() - replace_self_time > waittime):
					node = output
					get_node("texture").texture = load("res://textures/map/default/"+output+".png")
					replace_self_time = OS.get_system_time_secs()
	elif(type == "exactly"):
			if(get_tree().get_root().get_node_or_null("GAME/world/%d"%(nodeposx)+"%d"%(nodeposy)) and node == input2):
				if(get_tree().get_root().get_node_or_null("GAME/world/%d"%nodeposx+"%d"%nodeposy).node != input):
					if(OS.get_system_time_secs() - replace_self_time > waittime):
						node = output
						get_node("texture").texture = load("res://textures/map/default/"+output+".png")
func save_node():
	var file2 = File.new()
	file2.open(game_path+"/blocks/"+name+".node", File.WRITE)
	file2.store_line(to_json(node_data))
	file2.close()
func load_node():
	var file = File.new()
	file.open(game_path+"/blocks/%d"%position.x+"%d"%position.y+".node", File.READ)
	node_data = parse_json(file.get_as_text())
	print("Loading:")
	print("%d"%position.x+"%d"%position.y)
	print(parse_json(file.get_as_text()))
	print(node_data)

func interact_in_block():
	var mx = get_global_mouse_position().x
	var my = get_global_mouse_position().y
	var px = get_tree().get_root().get_node("GAME/player").position.x
	var py = get_tree().get_root().get_node("GAME/player").position.y
	if(px > position.x-300 and px < position.x+300 and py > position.y-300 and py < position.y+300):
		if(mx > position.x-25 and mx < position.x+25 and my > position.y-25 and my < position.y+25):
			get_node("texture").modulate.b = 0
			if(Input.is_mouse_button_pressed(BUTTON_LEFT)):
				node_data.name2 = "air"
				node_data.texture2 = ""
				node_data.collision = false
				get_node("CollisionShape2D").disabled = true
				get_node("texture").texture = null
				save_node()
		else:
			get_node("texture").modulate.b = 1
