extends Node

onready var symlink = get_node("/root/MainSymlink")
var server_data_config = {}
onready var ports = get_node("/root/ServerWebsocketPorts")
onready var file = get_node("/root/lib_main")
var websocket = WebSocketServer.new()
var cfg2
var _lobby = WebSocketServer.new()

var clients = []
var server_state = false
var KEY = CryptoKey.new()
var CRT_DATA = X509Certificate.new()

var CN = "PlatGen"
var O = "GP Kuba Graczykowski"
var C = "PL"
var start_data = "20210514000000"
var finish_data = "20220514000000"

var MAX_LOBBY_PLAYER_LIMIT = 1

func check_ports(min_port, max_port, server_type):
	var tick = 0
	var check
	if(server_type == "Server"):
		check = websocket.listen(min_port)
	else:
		check = _lobby.listen(min_port)
	while(tick <= max_port and check != OK):
		tick += 1
		if(server_type == "Server"):
			check = websocket.listen(min_port+tick)
		else:
			check = _lobby.listen(min_port+tick)
	if(check != OK):
		symlink.console_output("["+server_type+"] Failed to listen "+server_type+" between %d"%min_port+" - %d"%max_port+" ports. Error output: "+check, "err")
		self.name = "TO REMOVE SERVER%d"%OS.get_system_time_msecs()
		self.queue_free()
		return null
	else:
		symlink.console_output("["+server_type+"] Listen "+server_type+" port founded - %d"%(min_port+tick), "info")
		return {"port":(min_port+tick), "check_result":check}

func _ready():
	MainSymlink.console_output("[Server - Boot] Cleaning buffor area...")
	lib_main.rmdir("user://server_buffor", false)
	rng.randomize()
	MainSymlink.console_output("[Server] Initializing server instance...")
	websocket.connect("client_connected", self, "_client_connected")
	websocket.connect("client_disconnected", self, "_client_disconnected")
	websocket.connect("client_close_request", self, "_client_close_request")
	websocket.connect("data_received", self, "_data")
	_lobby.connect("client_connected", self, "_lobby_cc")
	_lobby.connect("client_disconnected", self, "_lobby_cd")
	_lobby.connect("client_close_request", self, "_lobby_ce")
	_lobby.connect("data_received", self, "_lobby_data")
	var _lobby_key = CryptoKey.new()
	_lobby_key.load("res://certificates/servkey.key")
	var _lobby_cert = X509Certificate.new()
	_lobby_cert.load("res://certificates/servcert.crt")
	_lobby.private_key = _lobby_key
	_lobby.ssl_certificate = _lobby_cert
	cfg2 = lib_main.rdfile("user://network_cfg/server.cfg", "json")
	var tx = OS.get_datetime()
	start_data = str(tx["year"])
	if(str(tx["month"]).length() == 1):
		start_data += "0"+str(tx["month"])
	else:
		start_data += str(tx["month"])
	if(str(tx["day"]).length() == 1):
		start_data += "0"+str(tx["day"])
	else:
		start_data += str(tx["day"])
	start_data += "000000"
	finish_data = str(tx["year"]+1)
	if(str(tx["month"]).length() == 1):
		finish_data += "0"+str(tx["month"])
	else:
		finish_data += str(tx["month"])
	if(str(tx["day"]).length() == 1):
		finish_data += "0"+str(tx["day"])
	else:
		finish_data += str(tx["day"])
	finish_data += "000000"
	certificate_gen()
	websocket.private_key = KEY
	websocket.ssl_certificate = CRT_DATA
	websocket.ca_chain = CRT_DATA
	var result = check_ports(ports.min_search_port, ports.max_search_port, "Server")
		
	#print(websocket.get_bind_ip())
	if(result != null):
		server_data_config.port = result.port
		server_data_config.check_result = result.check_result
		get_node("/root/ClientWebsocketPorts").local_server_port = result.port
		server_state = true
		MainSymlink.console_output("[Server - World Gen] Initializing world...")
		_init_game()
		if(cfg2.work_type != "local"):
			var _lobby_port = check_ports(17045, 17045, "Lobby")
			if(_lobby_port != null):
				symlink.console_output("[Lobby] Lobby server started.", "")
			else:
				symlink.console_output("[Lobby] Failed to listen Global lobby on port 17045", "warn")
	else:
		set_process(false)
		symlink.console_output("[Server] Stopping server...", "")

func _process(_delta):
	if(websocket.is_listening()):
		websocket.poll()
		#_game_process()
		_server_process()
	if(_lobby.is_listening()):
		_lobby.poll()
		_lobby_process()

func _client_connected(id, protocol = "none"):
	symlink.console_output("[Server] Client connected with protocol: "+protocol+" - ID: %d"%id, "")
	clients += [id]
	ping += [0]
	_server_regtime += [OS.get_system_time_msecs()]
	_client_transform += [id, {"x":0, "y":0, "rotation":0, "scale":{"x":1, "y":1}}]
func _client_disconnected(id, disconnect_cleanly):
	ping.remove(clients.find(id))
	if(disconnect_cleanly):
		symlink.console_output("[Server] Client [%d"%id+"] has been disconnected successfully.", "")
	else:
		symlink.console_output("[Server] Client [%d"%id+"] has been disconnected not safely.", "")
	_server_regtime.remove(clients.find(id))
	clients.remove(clients.find(id))
	if(_client_transform.has(id)):
		_client_transform.remove(_client_transform.find(id)+1)
		_client_transform.remove(_client_transform.find(id))
	if(_client_input.has(id)):
		_client_input.remove(_client_input.find(id)+1)
		_client_input.remove(_client_input.find(id))
func _client_close_request(id, protocol, reason = "no reason (timed out?)"):
	symlink.console_output("[Server] Client [%d"%id+"] was disconnected with reason -[ "+reason+" ]- on protocol: "+protocol, "")

func _exit_tree():
	if(server_state):
		websocket.stop()
	if(_lobby.is_listening()):
		_lobby.stop()

var ping = []

func _update_ping(id):
	ping[clients.find(id)] = OS.get_system_time_msecs() - _server_regtime[clients.find(id)]
	_server_regtime[clients.find(id)] = OS.get_system_time_msecs()

func _get_data(id):
	var pck = JSON.parse(websocket.get_peer(id).get_packet().get_string_from_utf8())
	var error = pck.get_error()
	if(error != 0):
		websocket.disconnect_peer(id, 400, "Wrong package.")
		return 1
	else:
		var pkg = pck.result
		return pkg

onready var package_manager = load("res://networking/server_package_manager.gd")

func _data(client_id):
	_update_ping(client_id)
	var data = _get_data(client_id)
	package_manager._package_manager(client_id, data)


#	symlink.console_output("[Server] Client [%d"%client_id+"] sended some package.", "")
#	var state_one = false
#	var pck = JSON.parse(websocket.get_peer(client_id).get_packet().get_string_from_utf8())
#	var pkg = pck.result
#	var get_error = pck.get_error()
#	if(get_error == 0):
#		state_one = true
#	if(pkg.has("type") and state_one):
#		if(pkg.type == "content"):
#			_ASK_package_manager(client_id, pkg)
#		else:
#			websocket.disconnect_peer(client_id, 400, "Invalid package sent.")
#			symlink.console_output("[Server].[Err 1] Client '%d"%client_id+"' sent invalid JSON package, so client was kicked.", "")
#	else:
#		websocket.disconnect_peer(client_id, 400, "Invalid package sent.")
#		symlink.console_output("[Server].[Err 1] Client '%d"%client_id+"' sent invalid JSON package, so client was kicked.", "")

func send_package(data, client_id):
	_update_ping(client_id)
	var check_data = data.typeof()
	if(check_data == JSON):
		websocket.get_peer(client_id).put_packet(JSON.print(data).to_utf8())
	else:
		var json = {"_unorganized":data}
		websocket.get_peer(client_id).put_packet(JSON.print(json).to_utf8())

func certificate_gen():
	symlink.console_output("[Server] Starting generating new certificate...", "")
	var crypto_cfg = "CN="+CN+",O="+O+",C="+C
	var crypto = Crypto.new()
	var ckey = CryptoKey.new()
	ckey = crypto.generate_rsa(4096)
	var cert = X509Certificate.new()
	cert = crypto.generate_self_signed_certificate(ckey, crypto_cfg, start_data, finish_data)
	if(OS.is_debug_build()):
		cert.save("res://certificates/servcert.crt")
		ckey.save("res://certificates/servkey.key")
	cert.save("user://network_cfg/certificates/servcert.crt")
	ckey.save("user://network_cfg/certificates/servkey.key")
	KEY = ckey
	CRT_DATA = cert
	symlink.console_output("[Server] Certificate successfully made.", "")

var _lobby_clients = []
var _lobby_nicknames = []
var _lobby_ips = []
var _lobby_regtime = []

func _lobby_cc(id, protocol):
	if not(_lobby_clients.size() > MAX_LOBBY_PLAYER_LIMIT):
		if not(_lobby_ips.has(_lobby.get_peer_address(id))):
			_lobby_ips += [_lobby.get_peer_address(id)]
			_lobby_clients += [id]
			_lobby_regtime += [OS.get_system_time_secs()]
			symlink.console_output("[Lobby] Client '%d"%id+"' joined to lobby with protocol: "+protocol+", on IP: '"+_lobby.get_peer_address(id)+"' at ["+lib_main.generate_time()+"].", "")
		else:
			_lobby.disconnect_peer(id, 406, "Multi-connection detected, DISCONNECTING")

func _lobby_cd(id, type):
	if(_lobby_clients.has(id)):
		var _lobby_pos = _lobby_clients.find(id)
		_lobby_clients.remove(_lobby_pos)
		_lobby_ips.remove(_lobby_pos)
		_lobby_regtime.remove(_lobby_pos)
	symlink.console_output("[Lobby] Client '%d"%id+"' leaved from lobby.", "")
	if(type):
		symlink.console_output("[Lobby] This leaving was safe.", "")
	else:
		symlink.console_output("[Lobby] This leaving was not safe.", "")

func _lobb_ce(id, protocol, reason):
	symlink.console_output("[Lobby] Client '"+id+"' on protocol: '"+protocol+"' request exit. Reason: "+reason, "")
	_lobby.disconnect_peer(id, 1800, "Client exit code OK")


func _lobby_data(id):
	var state_one = false
	#var pkg = null
	var pck = JSON.parse(_lobby.get_peer(id).get_packet().get_string_from_utf8())
	var pkg = pck.result
	var get_error = pck.get_error()
	if(get_error == 0):
		state_one = true
		#pkg = _lobby.get_peer(id).get_packet().get_string_from_utf8()
	#symlink.console_output("[Lobby] State: "+str(state_one))
	if not(str(pkg).length() > 100):
		symlink.console_output("[Lobby] Package get: "+str(pkg)+"\n from Client '"+str(id)+"' [IP:"+str(_lobby.get_peer_address(id))+"]", "")
	if(pkg.has("type") and state_one):
		if(pkg.type == "fast_data"):
			if(pkg.has("nickname")):
				if not(_lobby_nicknames.has(pkg.nickname)):
					_lobby_nicknames += [pkg.nickname]
					_lobby_send_package(id, {"type":"cert", "cert":lib_main.rdfile("user://network_cfg/certificates/servcert.crt", ""), "port":ClientWebsocketPorts.local_server_port})
				else:
					_lobby.disconnect_peer(id, 1200, "This nickname is already online on the server. Try again.")
					symlink.console_output("[Lobby] Client '"+id+"' sent nickname that was already registered in database, so client was kicked.", "")
			else:
				_lobby.disconnect_peer(id, 400, "Invalid package sent.")
				symlink.console_output("[Lobby].[Err 3] Client '"+id+"' sent invalid JSON package, so client was kicked.", "")
		elif(pkg.type == "READY"):
			# send ready info
			_lobby_send_package(id, {"type":"READY"})
			pass
		elif(pkg.type == "PACKAGE_READY"):
			_lobby_send_package(id, {"type":"BE READY"})
			_lobby.disconnect_peer(id, 1000, "__READY_FOR_CONNECT")
			symlink.console_output("[Lobby] Client '"+str(id)+"' is ready to connect.", "")
		else:
			_lobby.disconnect_peer(id, 400, "Invalid package sent.")
			symlink.console_output("[Lobby].[Err 2] Client '"+id+"' sent invalid JSON package, so client was kicked.", "")
	else:
		_lobby.disconnect_peer(id, 400, "Invalid package sent.")
		symlink.console_output("[Lobby].[Err 1] Client '%d"%id+"' sent invalid JSON package, so client was kicked.", "")

func _lobby_send_package(id, data):
	if not(str(data).length() > 100):
		symlink.console_output("[Lobby] Package sent: "+str(data)+" , to ID: "+str(id))
	_lobby.get_peer(id).put_packet(JSON.print(data).to_utf8())

var _lobby_ticker = 0

func _lobby_process():
	if(_lobby_clients.size() > 0):
		if(OS.get_system_time_secs() - _lobby_regtime[_lobby_ticker] > 18):
			#_lobby_ips.remove(_lobby_ticker)
			#_lobby_regtime.remove(_lobby_ticker)
			var id = _lobby_clients[_lobby_ticker]
			#_lobby_clients.remove(_lobby_ticker)
			_lobby.disconnect_peer(id, 504, "Timed out")
		_lobby_ticker += 1
		if(_lobby_ticker+1 > _lobby_clients.size()):
			_lobby_ticker = 0
	else:
		_lobby_ticker = 0

var _server_regtime = []
var _server_ticker = 0

func _server_process():
	if(_server_regtime.size() > 0):
		if(OS.get_system_time_msecs() - _server_regtime[_server_ticker] > 18000):
			#clients.remove(_server_ticker)
			#_server_regtime.remove(_server_ticker)
			var id = clients[_server_ticker]
			#_lobby_clients.remove(_server_ticker)
			websocket.disconnect_peer(id, 504, "Timed out")
			MainSymlink.console_output("[Server] Disconnecting client ["+str(id)+"] by Timed out.")
		_server_ticker += 1
		if(_server_ticker+1 > _server_regtime.size()):
			_server_ticker = 0
	else:
		_server_ticker = 0

### REAL GAME ###

var _world_config = {"mode":"spectator"}
var _cache_data_objects = []
var _game_gen = []
var _game_noise_texture = OpenSimplexNoise.new()
var _game_seed = 000000
var rng = RandomNumberGenerator.new()
var _content_pack = {"blocks":[], "characters":[], "events":[]}

func _game_process():
	_input_move()

func _init_game():
	_prepare_buffor_area()
	_initialize_game_vars()
	_initialize_world()
	_load_world()
	#_generate_objects_cache()

func _initialize_game_vars():
	if(MainSymlink._LOAD_TYPE == "new"):
		_game_gen = lib_main.rdfile(MainSymlink._game_gen_path, "var")
		lib_main.mkfile("user://server_buffor/generator.var", "var", _game_gen)
		_game_seed = MainSymlink._game_seed
		lib_main.mkfile("user://server_buffor/seed.seed", "", _game_seed)
		lib_main.mkdir("user://server_buffor/blocks")
		lib_main.mkdir("user://server_buffor/events")
		lib_main.mkdir("user://server_buffor/characters")
		lib_main.mkdir("user://server_buffor/world")
		lib_main.mkdir("user://server_buffor/configs")
		lib_main.mkdir("user://server_buffor/player_cfg")
		var entities_cfg = [[], [], [], [], [], [], [], []]
		lib_main.mkfile("user://server_buffor/entities.info", "var", entities_cfg)
		for copy_path in MainSymlink._used_blocks:
			lib_main.cpfile(copy_path, "user://server_buffor/blocks")
			_content_pack.blocks += ["user://server_buffor/blocks/"+copy_path.get_file()]
		for copy_path in MainSymlink._used_characters:
			lib_main.cpfile(copy_path, "user://sever_buffor/characters")
			_content_pack.characters += ["user://server_buffor/characters/"+copy_path.get_file()]
		for copy_path in MainSymlink._used_events:
			lib_main.cpfile(copy_path, "user://server_buffor/events")
			_content_pack.events += ["user://server_buffor/events/"+copy_path.get_file()]
		lib_main.mkfile("user://server_buffor/content.pack", "json", _content_pack)
		lib_main.mkfile("user://server_buffor/world.cfg", "json", MainSymlink.world_config)
	else:
		lib_main.cp(MainSymlink._game_save_path, "user://server_buffor", false)
		_game_gen = lib_main.rdfile("user://server_buffor/generator.var", "var")
		_game_seed = lib_main.rdfile("user://server_buffor/seed.seed", "")
		_content_pack = lib_main.rdfile("user://server_buffor/content.pack", "json")
		var entities_cfg = lib_main.rdfile("user://server_buffor/entities.info", "var")
		_world_entities = entities_cfg[0]
		_world_entities_cfg = entities_cfg[1]
		_world_entities_rotation = entities_cfg[2]
		_world_entities_scale_x = entities_cfg[3]
		_world_entities_scale_y = entities_cfg[4]
		_world_entities_x = entities_cfg[5]
		_world_entities_y = entities_cfg[6]
		_world_entities_ID = entities_cfg[7]
		MainSymlink.world_config = lib_main.rdfile("user://server_buffor/world.cfg", "json")

func _initialize_world():
	_game_noise_texture.octaves = _game_gen[1].main_noise.octaves
	_game_noise_texture.period = _game_gen[1].main_noise.period
	_game_noise_texture.persistence = _game_gen[1].main_noise.persistence
	_game_noise_texture.seed = _game_seed
	rng.seed = _game_seed
	rng.randomize()

func _generate_objects_cache():
	var tick = 0
	for object in _game_gen[1].objects_meta:
		var path = object.path
		var object_name = _game_gen[1].objects[tick*3-1]
		if(path != "null"):
			var object_cache = load(path).instance()
			_cache_data_objects += [{"path":path, "name":object_name, "cache":object_cache}]
		tick += 1

func _prepare_buffor_area():
	MainSymlink.console_output("[Server - Boot] Preparing buffor area...")
	_define_world()

func _load_world():
	var object = load("res://scenes/world_manager.tscn").instance()
	object._world_config = _world_config
	object._game_gen = _game_gen
	object._game_noise_texture = _game_noise_texture
	object._game_seed = _game_seed
	object._content_pack = _content_pack
	self.add_child(object)

func _block_not_found(block_name, client_id):
	send_package({"block_file":lib_main.rdfile("user://server_buffor/blocks/"+block_name+".tscn", ""), "block_name":block_name, "content":"block_file"}, client_id)

func _get_block(x, y, client_id):
	var block
	if not(lib_main.check("user://server_buffor/world/"+str(x)+"_"+str(y)+".block_pos")):
		block = _initialize_object(x, y)
		lib_main.mkfile("user://server_buffor/world/"+str(x)+"_"+str(y)+".block_pos", "", block)
	else:
		block = lib_main.rdfile("user://server_buffor/world/"+str(x)+"_"+str(y)+".block_pos", "")
	send_package({"block_out":block.get_basename(), "x":x, "y":y, "content":"block_noise"}, client_id)

func _initialize_object(x, y):
	var noise = _game_noise_texture.get_noise_2d(x, y)
	var biomes_tick = 0
	var biomes = []
	for biome_cfg in _game_gen[1].biomes_meta:
		if(noise > biome_cfg.render.noise.min and biome_cfg.render.noise.max > noise):
			if(biome_cfg.render.zone.x.min != 0 and biome_cfg.render.zone.x.max != 0):
				if(biome_cfg.render.zone.y.min != 0 and biome_cfg.render.zone.y.max != 0):
					if(x > biome_cfg.render.zone.x.min and x < biome_cfg.render.zone.x.max and y > biome_cfg.render.zone.y.min and y < biome_cfg.render.zone.y.max):
						biomes += [biomes_tick]
				else:
					if(x > biome_cfg.render.zone.x.min and x < biome_cfg.render.zone.x.max):
						biomes += [biomes_tick]
			else:
				if(biome_cfg.render.zone.y.min != 0 and biome_cfg.render.zone.y.max != 0):
					if(y > biome_cfg.render.zone.y.min and y < biome_cfg.render.zone.y.max):
						biomes += [biomes_tick]
				else:
					biomes += [biomes_tick]
		biomes_tick += 1
	
	if(biomes.size() > 0):
		var biome_select = biomes[round(rng.randf_range(0, biomes.size()-1))]
		
		
		var objects_tick = 0
		var objects = []
		for object_cfg in _game_gen[1].objects_meta:
			if(Array(object_cfg.biomes).has(biome_select)):
				if(noise > object_cfg.render.pos.min and object_cfg.render.pos.max > noise):
					if(object_cfg.render.height.max.bool):
						if(y < object_cfg.render.height.max.value):
							if(object_cfg.render.height.min.bool):
								if(y > object_cfg.render.height.min.value):
									if(object_cfg.render.width.max.bool):
										if(x < object_cfg.render.width.max.value):
											if(object_cfg.render.width.min.bool):
												if(x > object_cfg.render.width.min.value):
													objects += [objects_tick]
											else:
												objects += [objects_tick]
									else:
										if(object_cfg.render.width.min.bool):
											if(x > object_cfg.render.width.min.value):
												objects += [objects_tick]
										else:
											objects += [objects_tick]
							else:
								if(object_cfg.render.width.max.bool):
									if(x < object_cfg.render.width.max.value):
										if(object_cfg.render.width.min.bool):
											if(x > object_cfg.render.width.min.value):
												objects += [objects_tick]
										else:
											objects += [objects_tick]
								else:
									if(object_cfg.render.width.min.bool):
										if(x > object_cfg.render.width.min.value):
											objects += [objects_tick]
									else:
										objects += [objects_tick]
					else:
						if(object_cfg.render.height.min.bool):
							if(y > object_cfg.render.height.min.value):
								if(object_cfg.render.width.max.bool):
									if(x < object_cfg.render.width.max.value):
										if(object_cfg.render.width.min.bool):
											if(x > object_cfg.render.width.min.value):
												objects += [objects_tick]
										else:
											objects += [objects_tick]
								else:
									if(object_cfg.render.width.min.bool):
										if(x > object_cfg.render.width.min.value):
											objects += [objects_tick]
									else:
										objects += [objects_tick]
						else:
							if(object_cfg.render.width.max.bool):
								if(x < object_cfg.render.width.max.value):
									if(object_cfg.render.width.min.bool):
										if(x > object_cfg.render.width.min.value):
											objects += [objects_tick]
									else:
										objects += [objects_tick]
							else:
								if(object_cfg.render.width.min.bool):
									if(x > object_cfg.render.width.min.value):
										objects += [objects_tick]
								else:
									objects += [objects_tick]
			objects_tick += 1
		if(objects.size() > 0):
			var object_select = objects[round(rng.randf_range(0, objects.size()-1))]
			return _game_gen[1].objects_meta[object_select].path
		else:
			return null
	else:
		return null

var _client_input = []
var _client_transform = []

func _client_input_change(client_id, input_key, value):
	if not(_client_input.has(client_id)):
		_client_input += [client_id]
		_client_input += [[input_key, value]]
	else:
		var input_info = _client_input[_client_input.find(client_id)+1]
		if(input_info.has(input_key)):
			input_info[1+input_info.find(input_key)] = value
		else:
			input_info += [input_key, value]
		_client_input[_client_input.find(client_id)+1] = input_info

func _ASK_package_manager(client_id, package):
	if(package.has("content") == false):
		websocket.disconnect_peer(client_id, 400, "Bad Request (wrong package).")
	else:
		if(package.content == "block_load_request"):
			if(package.has("x") and package.has("y")):
				_on_block_request_event(client_id, package.x, package.y)
			else:
				websocket.disconnect_peer(client_id, 400, "Missing arguments.")
		elif(package.content == "block_not_found"):
			if(package.has("block_name")):
				_on_block_not_found_request_event(client_id, package.block_name)
			else:
				websocket.disconnect_peer(client_id, 400, "Missing arguments.")
		elif(package.content == "_input"):
			if(package.has("input_key") and package.has("value")):
				_client_input_change(client_id, package.input_key, package.value)
			else:
				websocket.disconnect_peer(client_id, 400, "Missing arguments.")
		

func _on_block_request_event(client_id, x, y):
	var client_transform = _client_transform[_client_transform.find(client_id)+1]
	if(x > client_transform.x+20 or x < client_transform.x-20 or y > client_transform.y+20 or y < client_transform.y-20):
		websocket.disconnect_peer(client_id, 400, "Bad Request (wrong block request)")
	else:
		_get_block(x, y, client_id)

func _on_block_not_found_request_event(client_id, block_name):
	if(lib_main.check("user://server_buffor/blocks/"+block_name+".tscn")):
		_block_not_found(block_name, client_id)
	else:
		websocket.disconnect_peer(client_id, 404, "Block not found.")
	

### ENTITIES ###

var _world_entities = []
var _world_entities_x = []
var _world_entities_y  = []
var _world_entities_rotation = []
var _world_entities_scale_x = []
var _world_entities_scale_y = []
var _world_entities_cfg = []
var _world_entities_ID = []

func _entity_not_found(client_id, entity_name):
	send_package({"entity_file":lib_main.rdfile("user://server_buffor/characters/"+entity_name+".tscn", ""), "entity_name":entity_name, "content":"entity_file"}, client_id)

func _load_entities(client_id):
	var client_transform = _client_transform[_client_transform.find(client_id)+1]
	var _send_entities = []
	for x_pos in _world_entities_x:
		if(x_pos > client_transform.x-2000 and x_pos < client_transform.y+2000):
			var y_pos = _world_entities_y[_world_entities_x.find(x_pos)]
			if(y_pos > client_transform.y-2000 and y_pos < client_transform.y+2000):
				var entity_CFG = _world_entities_cfg[_world_entities_x.find(x_pos)]
				_send_entities += [[_world_entities[_world_entities_x.find(x_pos)], x_pos, y_pos, _world_entities_rotation[_world_entities_x.find(x_pos)], _world_entities_scale_x[_world_entities_x.find(x_pos)], _world_entities_scale_y[_world_entities_x.find(x_pos)], entity_CFG, _world_entities_ID[_world_entities_x.find(x_pos)]]]
	send_package({"content":"entities", "entities":_send_entities}, client_id)

func _add_entity(entity_name, data = {"cfg":[], "x":0, "y":0, "scale_x":0, "scale_y":0, "rotation":0}):
	_world_entities += [entity_name]
	_world_entities_cfg += [data.cfg]
	_world_entities_x += [data.x]
	_world_entities_y += [data.y]
	_world_entities_rotation += [data.rotation]
	_world_entities_scale_x += [data.scale_x]
	_world_entities_scale_y += [data.scale_y]
	_world_entities_ID += [rng.randf_range(OS.get_system_time_msecs(), OS.get_system_time_msecs()*OS.get_system_time_secs())]
	_save_entity_progress()

func _remove_entity(entity_name, x, y):
	if(_world_entities.has(entity_name)):
		for entity in _world_entities:
			if(entity == entity_name):
				var pos = _world_entities.find(entity)
				if(_world_entities_x[pos] == x and _world_entities_y[pos] == y):
					_world_entities.remove(pos)
					_world_entities_cfg.remove(pos)
					_world_entities_rotation.remove(pos)
					_world_entities_scale_x.remove(pos)
					_world_entities_scale_y.remove(pos)
					_world_entities_x.remove(pos)
					_world_entities_y.remove(pos)
					_world_entities_ID.remove(pos)
					_save_entity_progress()

func _modify_entity(entity_name, x, y, type, value):
	if(_world_entities.has(entity_name)):
		for entity in _world_entities:
			if(entity == entity_name):
				var pos = _world_entities.find(entity)
				if(_world_entities_x[pos] == x and _world_entities_y[pos] == y):
					if(type == "CFG" or type == "cfg"):
						_world_entities_cfg[pos] = value
					elif(type == "x"):
						_world_entities_x[pos] = value
					elif(type == "y"):
						_world_entities_y[pos] = value
					elif(type == "scale_x"):
						_world_entities_scale_x[pos] = value
					elif(type == "scale_y"):
						_world_entities_scale_y[pos] = value
					elif(type == "rotation"):
						_world_entities_rotation[pos] = value
					_save_entity_progress()

func _modify_entity_ID(id, type, value):
	if(_world_entities_ID.has(id)):
		var pos = _world_entities_ID.find(id)
		_modify_entity(_world_entities[pos], _world_entities_x[pos], _world_entities_y[pos], type, value)

func _remove_entity_ID(id):
	if(_world_entities_ID.has(id)):
		var pos = _world_entities_ID.find(id)
		_remove_entity(_world_entities[pos], _world_entities_x[pos], _world_entities_y[pos])

func _save_entity_progress():
	var entities_cfg = [_world_entities, _world_entities_cfg, _world_entities_rotation, _world_entities_scale_x, _world_entities_scale_y, _world_entities_x, _world_entities_y, _world_entities_ID]
	lib_main.mkfile("user://server_buffor/entities.info", "var", entities_cfg)

### INPUT ANALYSIS ###

var _input_move_tick = 0

func _input_move():
	if(_client_input.size() > 0):
		var input_info = _client_input[_input_move_tick+1]
		if(input_info.has("move_x")):
			if(input_info[1+input_info.find("move_x")] != false):
				var _client_info_transform = _client_transform[_client_transform.find(_client_input[_input_move_tick])]
				if(_world_config.mode == "spectator"):
					_client_info_transform.x += input_info[1+input_info.find("move_x")]
		if(input_info.has("move_y")):
			if(input_info[1+input_info.find("move_y")] != false):
				var _client_info_transform = _client_transform[_client_transform.find(_client_input[_input_move_tick])]
				if(_world_config.mode == "spectator"):
					_client_info_transform.y += input_info[1+input_info.find("move_y")]
		if(_input_move_tick != _client_input.size()/2):
			_input_move_tick += 2
		else:
			_input_move_tick = 0
	else:
		_input_move_tick = 0

### CLIENT INIT ###

func _define_world():
	_world_config = MainSymlink.world_config
