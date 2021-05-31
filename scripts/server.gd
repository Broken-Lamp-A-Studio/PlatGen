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
	var result = check_ports(ports.min_search_port, ports.max_search_port, "Server")
		
	#print(websocket.get_bind_ip())
	if(result != null):
		server_data_config.port = result.port
		server_data_config.check_result = result.check_result
		get_node("/root/ClientWebsocketPorts").local_server_port = result.port
		server_state = true
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
	if(_lobby.is_listening()):
		_lobby.poll()
		_lobby_process()

func _client_connected(id, protocol = "none"):
	symlink.console_output("[Server] Client connected with protocol: "+protocol+" - ID: %d"%id, "")
	clients += [id]
func _client_disconnected(id, disconnect_cleanly):
	if(disconnect_cleanly):
		symlink.console_output("[Server] Client [%d"%id+"] has been disconnected successfully.", "")
	else:
		symlink.console_output("[Server] Client [%d"%id+"] has been disconnected not safely.", "")
	clients.remove(clients.has(id))
func _client_close_request(id, protocol, reason = "no reason (timed out?)"):
	symlink.console_output("[Server] Client [%d"%id+"] was disconnected with reason -[ "+reason+" ]- on protocol: "+protocol, "")

func _exit_tree():
	if(server_state):
		websocket.stop()
	if(_lobby.is_listening()):
		_lobby.stop()

func disconnect_everyone(code, reason):
	var t = 0
	while(t != clients.size()):
		websocket.close(clients[t], code, reason)
		t += 1
	clients = []

func _data(client_id):
	symlink.console_output("[Server] Client [%d"%client_id+"] sended some package", "")

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
			_lobby_ips.remove(_lobby_ticker)
			_lobby_regtime.remove(_lobby_ticker)
			var id = _lobby_clients[_lobby_ticker]
			_lobby_clients.remove(_lobby_ticker)
			_lobby.disconnect_peer(id, 504, "Timed out")
		_lobby_ticker += 1
		if(_lobby_ticker+1 > _lobby_clients.size()):
			_lobby_ticker = 0
	else:
		_lobby_ticker = 0
