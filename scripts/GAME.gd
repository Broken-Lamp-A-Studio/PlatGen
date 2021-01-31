extends Node2D

func _ready():
	get_node("player").set_process(false)
	get_node("player").set_physics_process(false)
	get_node("world").set_process(false)
	get_node("player/helmet-light").enabled = false
	get_node("player").gravity_scale = 0
	make_game()
	get_node("world").set_process(true)
onready var time = OS.get_system_time_msecs()
func _process(delta):
	if(Input.is_key_pressed(KEY_F11)):
		if(OS.get_system_time_msecs() - time > 100):
			OS.window_fullscreen = not OS.window_fullscreen
			time = OS.get_system_time_msecs()
func read_file(path):
	var file = File.new()
	file.open(path, File.READ)
	var data = file.get_line()
	file.close()
	return data
func make_game():
	var game_name = read_file("user://save/worldname.world")
	var game_path = read_file("user://save/save_files.data")+"/"+game_name
	make_dir(game_path)
	make_dir(game_path+"/blocks")
	make_file(game_path+"/world.world", "", "normal")
	get_node("world").game_path = game_path
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

var render = false

func game_stop():
	if(render == true):
		get_tree().paused = true
		get_node("player").set_process(false)
		get_node("player").set_physics_process(false)
		get_node("player").set_process_input(false)
		get_node("world").PAUSE_MODE_PROCESS
		get_node("player/CanvasLayer/inv").PAUSE_MODE_PROCESS

func game_play():
	if(render == true):
		get_tree().paused = false
		get_node("player").set_process(true)
		get_node("player").set_physics_process(true)
		get_node("player").set_process_input(true)
		get_node("world").PAUSE_MODE_STOP
		get_node("player/CanvasLayer/inv").PAUSE_MODE_STOP

