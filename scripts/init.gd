extends Node2D

var vx = 0
var vy = 0
onready var symlink = get_node("/root/MainSymlink")
onready var client_cfg = get_node("/root/ClientWebsocketPorts")
onready var server_cfg = get_node("/root/ServerWebsocketPorts")
onready var main = get_node("/root/lib_main")

func _ready():
	_load_sound_settings()
	_load_graphics_settings()
	initialize_user_tree()
	network_cfg()
	#OS.window_fullscreen = true
	#$"main-stuff/CenterContainer/Console Debug".open_scene("res://scenes/server.tscn")
	#$"main-stuff/CenterContainer/Console Debug".open_scene("res://scenes/client.tscn")
func set_main_cam(config2):
	$Camera2D.current = config2

func _process(_delta):
	_load_process()
	if(vx != get_viewport_rect().size.x or vy != get_viewport_rect().size.y):
		vx = get_viewport_rect().size.x
		vy = get_viewport_rect().size.y
		viewport_changed()

func viewport_changed():
	$Camera2D.position.x = get_viewport_rect().size.x/2
	$Camera2D.position.y = get_viewport_rect().size.y/2
	if(get_node_or_null("VideoPlayer")):
		get_node("VideoPlayer").rect_position.x = get_viewport_rect().size.x/2-get_node("VideoPlayer").rect_size.x/2
		get_node("VideoPlayer").rect_position.y = get_viewport_rect().size.y/2-get_node("VideoPlayer").rect_size.y/2

func network_cfg():
	var cfg = main.rdfile("user://network_cfg/server.cfg", "json")
	server_cfg.min_search_port = cfg.min_port
	server_cfg.max_search_port = cfg.max_port
	server_cfg.server_name = cfg.name
	cfg = main.rdfile("user://network_cfg/client.cfg", "json")
	client_cfg.min_search_ports = cfg.min_port
	client_cfg.max_search_ports = cfg.max_port
	client_cfg.local_server_port = cfg.l_server_port
	client_cfg.local_server_address = cfg.l_server_url

func initialize_user_tree():
	if(!main.check("user://network_cfg")):
		main.mkdir("user://network_cfg")
	if(!main.check("user://network_cfg/server.cfg")):
		main.mkfile("user://network_cfg/server.cfg", "json", {"min_port":20000, "max_port":30000, "name":"PlatGen_server", "work_type":"local"})
	if(!main.check("user://network_cfg/client.cfg")):
		main.mkfile("user://network_cfg/client.cfg", "json", {"min_port":20000, "max_port":30000, "l_server_port":20000, "l_server_url":"wss://localhost", "connection_type":"local"})
	if(!main.check("user://server_buffor")):
		main.mkdir("user://server_buffor")
	if(!main.check("user://saves")):
		main.mkdir("user://saves")
	if(!main.check("user://config")):
		main.mkdir("user://config")
	if(!main.check("user://config/settings.var")):
		main.mkfile("user://config/settings.var", "var", [])
	if(!main.check("user://config/worlds.var")):
		main.mkfile("user://config/worlds.var", "var", [])
	if(!main.check("user://editors")):
		main.mkdir("user://editors")
	if(!main.check("user://objects")):
		main.mkdir("user://objects")
	if(!main.check("user://objects/blocks")):
		main.mkdir("user://objects/blocks")
	if(!main.check("user://objects/characters")):
		main.mkdir("user://objects/characters")
	if(!main.check("user://objects/shaders")):
		main.mkdir("user://objects/shaders")
	if(!main.check("user://objects/generator.var")):
		main.mkfile("user://objects/generator.var", "var", [{"objects":[]}, {"setup":[]}])
	if(!main.check("user://objects/blocks.var")):
		main.mkfile("user://objects/blocks.var", "var", [])
	if(!main.check("user://config/gameplay.var")):
		main.mkfile("user://config/gameplay.var", "var", [])
	if(!main.check("user://network_cfg/certificates")):
		main.mkdir("user://network_cfg/certificates")
	if(!main.check("user://debug") and OS.is_debug_build()):
		main.mkdir("user://debug")
	if(!main.check("user://client_buffor")):
		main.mkdir("user://client_buffor")


func _on_VideoPlayer_finished():
	time3 = OS.get_system_time_msecs()
	$"main-stuff/load_screen".popup("Initializing...", 10)
	clear_workspace()
	_load_safe(["res://scenes/Main Menu.tscn"])
	#load_enviroment("res://scenes/client.tscn", true, false)

func clear_workspace():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for child in $envoirment.get_children():
		child.name = "TO REMOVE ENTITY%d"%OS.get_system_time_msecs()+str(round(rng.randf_range(-99999, 99999)))
		child.queue_free()

func load_enviroment(path, show_load_screen = true, initialize_load_screen = true, set_progress = -1):
	if(show_load_screen):
		if(set_progress == -1):
			if(initialize_load_screen):
				$"main-stuff/load_screen".popup("Loading '"+str(path.get_file().get_basename())+"'...", 50)
			else:
				if(check_popup_load_screen()):
					$"main-stuff/load_screen".update_progress("Loading '"+str(path.get_file().get_basename())+"'...", 50)
				else:
					$"main-stuff/load_screen".popup("Loading '"+str(path.get_file().get_basename())+"'...", 50)
		else:
			if(initialize_load_screen):
				$"main-stuff/load_screen".popup("Loading '"+str(path.get_file().get_basename())+"'...", set_progress)
			else:
				if(check_popup_load_screen()):
					$"main-stuff/load_screen".update_progress("Loading '"+str(path.get_file().get_basename())+"'...", set_progress)
				else:
					$"main-stuff/load_screen".popup("Loading '"+str(path.get_file().get_basename())+"'...", set_progress)
		
	else:
		$"main-stuff/load_screen".hide()
	$"main-stuff/CenterContainer/Console Debug".open_scene(str(path))

func get_progress():
	return $"main-stuff/load_screen/ProgressBar".value

func set_progress(progress):
	$"main-stuff/load_screen/ProgressBar".value = int(progress)

var to_load = []
var to_load_size = 0
onready var time3 = OS.get_system_time_msecs()

func check_popup_load_screen():
	if($"main-stuff/load_screen".visible):
		return true
	else:
		return false

func _load_process():
	if(to_load.size() > 0 and OS.get_system_time_msecs() - time3 > 5000):
		time3 = OS.get_system_time_msecs()
		to_load_size -= 1
		load_enviroment(to_load[0], true, false, get_progress()+(to_load_size))
		to_load.remove(0)
		if(to_load.size() == 0):
			_loaded()

func _load_safe(array = []):
	to_load = array
	to_load_size = round(100/array.size())
	set_progress(0)

func _loaded():
	$"main-stuff/load_screen".hide()

func _load_graphics_settings():
	var data = MainSymlink.graphics_settings
	OS.window_fullscreen = data.window_fullscreen
	OS.window_size.x = data.window_size_x
	OS.window_size.y = data.window_size_y
	OS.set_window_always_on_top(data.window_top)
	OS.vsync_enabled = data.vsync
	OS.screen_orientation = data.screen_orientation
	OS.window_borderless = data.border

func _load_sound_settings():
	var data = MainSymlink.sound_settings
	#var input = MainSymlink.sound_input
	var output = MainSymlink.sound_output
	
#	if(input.has(data.input_selected)):
#		MainSymlink.verify_sound_input = true
#		AudioServer.capture_set_device(data.input_selected)
#	else:
#		MainSymlink.verify_sound_input = false
#		if(AudioServer.capture_get_device_list().size() > 0):
#			AudioServer.capture_set_device(AudioServer.capture_get_device_list()[0])
	
	if(output.has(data.output_selected)):
		MainSymlink.verify_sound_output = true
		if(AudioServer.device != data.output_selected):
			AudioServer.device = data.output_selected
	else:
		MainSymlink.verify_sound_output = false
		AudioServer.device = "Default"
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), data.master)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Game_music"), data.music)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), data.effects)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Inv_effects"), data.inv_effects)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Machines"), data.machines)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Dialogs"), data.dialogs)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Videos"), data.videos)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voicechat"), data.voicechat)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MainVoice"), data.voice)
