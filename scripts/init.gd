extends Node2D

var vx = 0
var vy = 0
onready var symlink = get_node("/root/MainSymlink")
onready var client_cfg = get_node("/root/ClientWebsocketPorts")
onready var server_cfg = get_node("/root/ServerWebsocketPorts")
onready var main = get_node("/root/lib_main")

func _ready():
	initialize_user_tree()
	network_cfg()
	$"main-stuff/CenterContainer/Console Debug".open_scene("res://scenes/server.tscn")
	$"main-stuff/CenterContainer/Console Debug".open_scene("res://scenes/client.tscn")
func set_main_cam(config2):
	$Camera2D.current = config2

func _process(_delta):
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
