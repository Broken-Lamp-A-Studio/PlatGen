extends Node


var backup_path = "user://backup/"
var graphics_settings = {}
var general_settings = {}
var sound_settings = {"microphone":0}
var sound_input = []
var sound_output = []

var verify_sound_input = true
var verify_sound_output = true

func _ready():
	AudioServer.capture_set_device("Default")
	_init_general()
	_init_graphics()
	_init_sound()

func _init_graphics():
	graphics_settings = _load_graphics_settings()

func _init_general():
	general_settings = _load_general_settings()
	backup_path = general_settings.backup

func _init_sound():
	_load_sound_input()
	_load_sound_output()
	sound_settings = _load_sound_settings()

func _save_general_settings():
	var data = {
		"processor":OS.low_processor_usage_mode,
		"backup":backup_path
	}
	general_settings = data
	lib_main.mkfile("user://general_config.json", "json", data)

func _load_general_settings():
	if(lib_main.check("user://general_config.json")):
		var data = lib_main.rdfile("user://general_config.json", "json")
		return data
	else:
		var data = {
		"processor":false,
		"backup":"user://backup/"
		}
		return data

func _save_graphics_settings():
	var data = {
		"window_fullscreen":OS.window_fullscreen,
		"window_size_x":OS.window_size.x,
		"window_size_y":OS.window_size.y,
		"window_top":OS.is_window_always_on_top(),
		"vsync":OS.vsync_enabled,
		"screen_orientation":OS.screen_orientation,
		"border":OS.window_borderless
	}
	graphics_settings = data
	lib_main.mkfile("user://graphics_config.json", "json", data)

func _load_graphics_settings():
	if(lib_main.check("user://graphics_config.json")):
		var data = lib_main.rdfile("user://graphics_config.json", "json")
		return data
	else:
		OS.window_fullscreen = false
		OS.window_size.x = 800
		OS.window_size.y = 600
		OS.set_window_always_on_top(false)
		OS.vsync_enabled = true
		OS.screen_orientation = 0
		OS.window_borderless = false
		var data = {
		"window_fullscreen":OS.window_fullscreen,
		"window_size_x":OS.window_size.x,
		"window_size_y":OS.window_size.y,
		"window_top":OS.is_window_always_on_top(),
		"vsync":OS.vsync_enabled,
		"screen_orientation":OS.screen_orientation,
		"border":OS.window_borderless
		}
		return data

func _save_sound_settings():
	var data = {
		"master":AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")),
		"music":AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Game_music")),
		"effects":AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Effects")),
		"inv_effects":AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Inv_effects")),
		"machines":AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Machines")),
		"videos":AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Videos")),
		"monsters":AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Monsters")),
		"voicechat":AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Voicechat")),
		"voice":AudioServer.get_bus_volume_db(AudioServer.get_bus_index("MainVoice")),
		"dialogs":AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Dialogs")),
		"output_selected":AudioServer.device,
		"input_selected":AudioServer.capture_get_device(),
		"microphone":sound_settings.microphone
	}
	sound_settings = data
	lib_main.mkfile("user://sound_config.json", "json", data)

func _load_sound_settings():
	if(lib_main.check("user://sound_config.json")):
		var data = lib_main.rdfile("user://sound_config.json", "json")
		return data
	else:
		var data = {
			"master":0,
			"music":0,
			"effects":0,
			"inv_effects":0,
			"machines":0,
			"videos":0,
			"monsters":0,
			"voicechat":0,
			"voice":0,
			"dialogs":0,
			"output_selected":"Default",
			"input_selected":"Default",
			"microphone":0
		}
		return data

func _load_sound_output():
	sound_output = AudioServer.get_device_list()

func _load_sound_input():
	sound_input = AudioServer.capture_get_device_list()

var console = "init/main-stuff/CenterContainer/Console Debug"

func popup_logo():
	get_tree().get_root().get_node("init/main-stuff/CenterContainer/PlatGen_move").popup()

func hide_logo():
	get_tree().get_root().get_node("init/main-stuff/CenterContainer/PlatGen_move").hide()

func switch_logo():
	get_tree().get_root().get_node("init/main-stuff/CenterContainer/PlatGen_move/AnimationPlayer").play("show_down2")

func show_info(text):
	get_tree().get_root().get_node("init/main-stuff/CenterContainer/message").show_info(text)

func show_warn(text):
	get_tree().get_root().get_node("init/main-stuff/CenterContainer/message").show_warn(text)

func show_error(text):
	get_tree().get_root().get_node("init/main-stuff/CenterContainer/message").show_error(text)

func console_output(msg, _type = "info"):
	if(get_tree().get_root().get_node_or_null(console)):
		if not(_type) or _type == "info":
			get_tree().get_root().get_node_or_null(console).get_msg(str(msg))
		elif(_type == "warn"):
			get_tree().get_root().get_node(console).get_warn(str(msg))
		elif(_type == "error" or _type == "err"):
			get_tree().get_root().get_node(console).get_error(str(msg))

var texture_editor = false
var collision_editor = false
var particle_editor = true

func set_music(array = []):
	if(get_tree().get_root().get_node_or_null("init/Music")):
		get_tree().get_root().get_node("init/Music").set_music(array)

func _load_scene(path):
	get_tree().get_root().get_node("init/main-stuff/CenterContainer/Console Debug").open_scene(path)

var game_version = "0.57"

### REAL GAME ###

var _LOAD_TYPE = "new"

var _used_blocks = []
var _used_characters = []
var _used_events = []
var _game_gen_path = "user://objects/generator.var"
var _game_seed = 00000000

var _game_save_path = ""

var world_config = {"mode":"spectator"}


### GAME CLIENT ###

var _game_client_cert = X509Certificate.new()
var _game_client_address = ""
var _game_client_port = 0
var _game_client_ping = 0

func crash():
	OS.alert("Uhhh, PlatGen crashed.", "Crash!")
# warning-ignore:return_value_discarded
	OS.shell_open("file://"+OS.get_user_data_dir()+"/logs/godot.log")
	get_tree().quit()
