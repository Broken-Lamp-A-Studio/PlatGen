extends Node


var console = "init/main-stuff/CenterContainer/Console Debug"

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
