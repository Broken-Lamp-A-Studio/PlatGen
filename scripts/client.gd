extends Node2D


onready var symlink = get_node("/root/MainSymlink")
onready var ports = get_node("/root/ClientWebsocketPorts")



var _client = WebSocketClient.new()
var cfg
var server_name = ""
var exit_reason = "Connection closed."
var SERV_CERT = X509Certificate.new()
var RIGHT_SERV_PORT = 0

func _ready():
	ports.global_server_port = 17045
	set_process(false)
	_client.connect("connection_closed", self, "_connection_stop")
	_client.connect("connection_error", self, "_connection_err")
	_client.connect("connection_established", self, "_connection_made")
	_client.connect("data_received", self, "_data")
	_client.connect("server_close_request", self, "_server_closed")
	cfg = lib_main.rdfile("user://network_cfg/client.cfg", "json")
	if(cfg.connection_type == "local"):
		var cert = X509Certificate.new()
		cert.load("user://network_cfg/certificates/servcert.crt")
		_client.trusted_ssl_certificate = cert
		
		_client.verify_ssl = false
		_client.connect_to_url(cfg.l_server_url+":"+"%d"%cfg.l_server_port)
		server_name = cfg.l_server_url+":"+"%d"%cfg.l_server_port
		set_process(true)
	else:
		var cert = X509Certificate.new()
		cert.load("res://certificates/servcert.crt")
		_client.trusted_ssl_certificate = cert
		_client.verify_ssl = false
		_client.connect_to_url(ports.global_server_address+":"+"%d"%ports.global_server_port)
		server_name = ports.global_server_address+":"+"%d"%ports.global_server_port
		set_process(true)
func _process(_delta):
	_client.poll()
	_serv_connection()

func _data():
	_serv_c_time = OS.get_system_time_msecs()
	var pck = JSON.parse(_client.get_peer(1).get_packet().get_string_from_utf8())
	#var pkg = JSON.parse(_client.get_peer(1).get_packet().get_string_from_utf8()).main
	var pkg = pck.result
	var get_error = pck.get_error()
	var state = false
	if(get_error == 0):
		state = true
		#pck = _client.get_peer(1).get_packet().get_string_from_utf8()
	if(pkg.has("type") and state):
		if(_client.get_connected_port() == 17045):
			if(pkg.type == "cert" and pkg.has("cert") and pkg.has("port")):
				var data = pkg.cert
				lib_main.mkfile("user://network_cfg/certificates/clientcert.crt", "", data)
				SERV_CERT.load("user://network_cfg/certificates/clientcert.crt")
				RIGHT_SERV_PORT = pkg.port
				_send_package({"type":"PACKAGE_READY"})
			elif(pkg.type == "BE READY"):
				_client.disconnect_from_host(1000, "Data downloaded.")
				connect_to_the_server(ports.global_server_address, RIGHT_SERV_PORT)
			elif(pkg.type == "READY"):
				_send_package({"type":"fast_data", "nickname":ports.nickname})
			else:
				symlink.console_output("[Client] Unknown package sent, DISCONNECTING", "")
				_client.disconnect_from_host(409, "Unknown package.")
				rm_self()
		else:
			pass
	else:
		symlink.console_output("[Client] Unknown package sent, DISCONNECTING", "")
		_client.disconnect_from_host(409, "Unknown package.")
		rm_self()

func _connection_stop(data = false):
	set_process(false)
	if(data):
		symlink.console_output("[Client] Connection stopped successfully.", "")
	else:
		symlink.console_output("[Client] Connection stopped not safely.", "warn")
		set_process(false)


func _connection_err(error = "?"):
	set_process(false)
	symlink.console_output("[Client] Failed to connect to the server ["+server_name+"]. Error: "+error, "warn")
	self.name = "TO REMOVE CLIENT%d"%OS.get_system_time_msecs()
	self.queue_free()

func _connection_made(protocol = "none"):
	_serv_c_time = OS.get_system_time_msecs()
	symlink.console_output("[Client] Connection established with the following protocol: "+protocol, "")
	if(_client.get_connected_port() == 17045):
		_send_package({"type":"READY"})

func _server_closed(code = 0, reason = "no reason (timed out?)"):
	set_process(false)
	symlink.console_output("[From Server] Closing server with the following code: %d"%code, "")
	symlink.console_output("Reason: "+reason, "")
	self.name = "TO REMOVE CLIENT%d"%OS.get_system_time_msecs()
	self.queue_free()

onready var _serv_c_time = OS.get_system_time_msecs()

func _serv_connection():
	if(OS.get_system_time_msecs() - _serv_c_time > 15000):
		_client.disconnect_from_host(408, "Timed out.")
		symlink.console_output("[Client] Connection between server was slower than 15 seconds, disconnecting...", "")
		self.name = "TO REMOVE CLIENT%d"%OS.get_system_time_msecs()
		self.queue_free()

func _send_package(data):
	_client.get_peer(1).put_packet(JSON.print(data).to_utf8())

func rm_self():
	self.name = "TO REMOVE CLIENT%d"%OS.get_system_time_msecs()
	self.queue_free()

func connect_to_the_server(address, port):
	MainSymlink._game_client_address = address
	MainSymlink._game_client_port = port
	MainSymlink._game_client_cert = SERV_CERT
	_on_start_connection()

func _on_start_connection():
	MainSymlink._load_scene("res://scenes/game_client.tscn")
	symlink.console_output("[Client] Terminating client side 1...")
	rm_self()
