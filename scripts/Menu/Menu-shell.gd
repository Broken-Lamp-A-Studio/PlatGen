extends Node2D

var config = []

func disable_light():
	get_node("effects/Light2D").enabled = false
	get_node("effects/Light2D2").enabled = false
	get_node("effects/Light2D3").enabled = false
	get_node("effects/Light2D4").enabled = false
	get_node("Background/objects/torch_on_1").visible = false
	get_node("Background/damaged-structures/1/Sprite4/Light2D").energy = 0
func enable_light():
	get_node("effects/Light2D").enabled = true
	get_node("effects/Light2D2").enabled = true
	get_node("effects/Light2D3").enabled = true
	get_node("effects/Light2D4").enabled = true
	get_node("Background/objects/torch_on_1").visible = true
onready var time = OS.get_system_time_msecs()
func _process(delta):
	if(OS.get_system_time_msecs() - time > 500):
		make_file("user://config.data", config, "json")
		time = OS.get_system_time_msecs()
func _ready():
	var dir = Directory.new()
	if not(dir.file_exists("user://config.data")):
		var json_data = {
			"save_game_path":"user://save",
			"fullscreen":false,
			"viewport_x_size":get_viewport_rect().size.x,
			"viewport_y_size":get_viewport_rect().size.y,
			"sound_all":100,
			"music_all":100,
			"effects_all":100,
			"inv_effects_all":100,
			"gui_scale":100,
			"language":"English",
			"mod_path":null,
			"game_mouse":true,
		}
		make_file("user://config.data", json_data, "json")
	config = read_file("user://config.data", "json")
func execute_quit():
	get_tree().quit()
func read_dir(path):
	var dir = Directory.new()
	var type = false
	if(dir.dir_exists(path)):
		type = true
	else:
		type = false
	return type
func make_dir(path):
	var dir = Directory.new()
	if not(read_dir(path)):
		dir.make_dir(path)
func make_file(path, data, type):
	var file = File.new()
	file.open(path, File.WRITE)
	if(type == "normal"):
		file.store_line(data)
	elif(type == "json"):
		var json_data = parse_json(data)
		file.store_line(to_json(json_data))
	file.close()
func read_file(path, type):
	var file = File.new()
	var dir = Directory.new()
	if(dir.file_exists(path)):
		file.open(path, File.READ)
		if(type == "normal"):
			return file.get_line()
		elif(type == "json"):
			return parse_json(file.get_as_text())
		file.close()
	else:
		return null
