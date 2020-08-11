extends Node2D

onready var time3 = OS.get_system_time_secs()
onready var time = OS.get_system_time_secs()
var x = 0
var f = File.new()
var n = "res://saved/worlds"+"obj%d" % OS.get_system_time_secs()
var mouse = 1

func _ready():
	get_node("map").set_process(true)
	get_node("map").generate = true
	get_node("map").visible = true
	get_node("player/Camera2D").visible = true
	get_node("player").visible = true
	get_node("player").set_process(true)
	get_node("player").set_process_input(true)
	get_node("player").set_physics_process(true)
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process(true)

func _process(delta):
	get_node("TileMap").multix = get_node("player").position.x
	get_node("TileMap").multiy = get_node("player").position.y
	get_node("LightMouse").x = get_node("player").position.x
	get_node("LightMouse").y = get_node("player").position.y
	if(OS.get_system_time_secs() - time > 10):
		get_node("map").generate = false
	if(Input.is_action_just_pressed("ui_cancel")):
		if(mouse == 0):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse = 1
		elif(mouse == 1):
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			mouse = 0
	
func render(direction):
	if(direction == 1):
		x = 50
		
func save():
	n = "res://saved/worlds/game"+"%d" % OS.get_system_time_msecs()
	n += ".save"
	f.open(n, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		f.store_line(to_json(node_data))
	f.close()
func game_load(gn):
	var save_game = File.new()
	if not save_game.file_exists(gn):
		return
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()
	save_game.open(gn, File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
	save_game.close()
