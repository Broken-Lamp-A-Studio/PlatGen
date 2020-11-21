extends StaticBody2D

var node = ""
var gui = false
var node_data = []
onready var replace_self_time = OS.get_system_time_secs()
var world_path = ""
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
func run(worldp, type, filename2):
	world_path = worldp
	


func setup(name2, node2, texture2, gui2, effects2, collsion, light, x2, y2):
	node_data = [name2, node2, texture2, gui2, effects2, collsion, light, x2, y2]
	position.x = x2
	position.y = y2
	var px2 = get_tree().get_root().get_node("GAME/player").position.x
	var py2 = get_tree().get_root().get_node("GAME/player").position.y
	if(position.x < px2+200 and position.x > px2-200 and position.y < py2+200 and position.y > py2-200):
		node_data[1] = "air"
		texture2 = ""
		collsion = false
	var dir = Directory.new()
	if(node2 != null or node2 != false or node2 != ""):
		node = node_data[1]
	else:
		print("ERROR: Node doesn't have name!")
	if(dir.file_exists(texture2)):
		get_node("texture").texture = load(texture2)
	else:
		get_node("texture").visible = false
	if(gui2 != null or gui2 != "" or gui2 != false):
		pass
	if(collsion):
		get_node("CollisionShape2D").disabled = true
	else:
		get_node("CollisionShape2D").disabled = false
	object_scale()
	if(node == "air" or texture2 == ""):
		get_node("CollisionShape2D").disabled = true
	else:
		get_node("CollisionShape2D").disabled = false
func visible2():
	var range_x = self.position.x+get_viewport_rect().size.x/2+50*5
	var range_y = self.position.y+get_viewport_rect().size.y/2+50*5
	var x = get_tree().get_root().get_node("GAME/player").position.x
	var y = get_tree().get_root().get_node("GAME/player").position.y
	if not(y < range_y and y > range_y-(get_viewport_rect().size.y/2+50*5)*2 and x < range_x and x > range_x-(get_viewport_rect().size.x/2+50*5)*2):
		self.queue_free()
func _process(delta):
	visible2()
	gui_move()

	
		
	replace_self("near", 0, -50, "air", "dirt_with_grass", "dirt", 5)
func replace_self(type, nodeposx, nodeposy, input, input2, output, waittime):
	if(type == "near"):
		if(get_tree().get_root().get_node_or_null("../%d"%(self.position.x+nodeposx)+"%d"%(self.position.y+nodeposy)) and node == input2):
			if(get_tree().get_root().get_node_or_null("../%d"%(self.position.x+nodeposx)+"%d"%(self.position.y+nodeposy)).node != input):
				if(OS.get_system_time_secs() - replace_self_time > waittime):
					node = output
					get_node("texture").texture = load("res://textures/map/default/"+output+".png")
					replace_self_time = OS.get_system_time_secs()
	elif(type == "exactly"):
			if(get_tree().get_root().get_node_or_null("../%d"%(nodeposx)+"%d"%(nodeposy)) and node == input2):
				if(get_tree().get_root().get_node_or_null("../%d"%nodeposx+"%d"%nodeposy).node != input):
					if(OS.get_system_time_secs() - replace_self_time > waittime):
						node = output
						get_node("texture").texture = load("res://textures/map/default/"+output+".png")
	
