extends Node

var _client = WebSocketClient.new()

func _ready():
	_client.connect("connection_closed", self, "_connection_stop")
	_client.connect("connection_error", self, "_connection_err")
	_client.connect("connection_established", self, "_connection_made")
	_client.connect("data_received", self, "_data")
	_client.connect("server_close_request", self, "_server_closed")
	_client.trusted_ssl_certificate = MainSymlink._game_client_cert
	_client.verify_ssl = false
	_client.connect_to_url(MainSymlink._game_client_address+":"+str(MainSymlink._game_client_port))
	set_process(true)
func rm_self():
	self.name = "TO REMOVE CLIENT%d"%OS.get_system_time_msecs()
	set_process(false)
	self.queue_free()

func _send_package(data):
	_client.get_peer(1).put_packet(JSON.print(data).to_utf8())
	_update_ping()

onready var _serv_c_time = OS.get_system_time_msecs()

func _serv_connection():
	if(OS.get_system_time_msecs() - _serv_c_time > 15000):
		_client.disconnect_from_host(408, "Timed out.")
		MainSymlink.console_output("[Game Client] Connection between server was slower than 15 seconds, disconnecting...", "")
		rm_self()

func _update_ping():
	MainSymlink._game_client_ping = OS.get_system_time_msecs()-_serv_c_time
	_serv_c_time = OS.get_system_time_msecs()

func _server_closed(code = 0, reason = "no reason (timed out?)"):
	set_process(false)
	MainSymlink.console_output("[From Server] Closing server with the following code: %d"%code, "")
	MainSymlink.console_output("Reason: "+reason, "")
	rm_self()

func _connection_stop(data = false):
	set_process(false)
	if(data):
		MainSymlink.console_output("[Game Client] Connection stopped successfully.", "")
	else:
		MainSymlink.console_output("[Game Client] Connection stopped not safely.", "warn")
		set_process(false)


func _connection_err(error = "?"):
	set_process(false)
	MainSymlink.console_output("[Game Client] Failed to connect to the server ["+MainSymlink._game_client_address+":"+str(MainSymlink._game_client_port)+"]. Error: "+error, "warn")
	rm_self()

func _connection_made(protocol = "none"):
	_update_ping()
	MainSymlink.console_output("[Game Client] Connection established with the following protocol: "+protocol, "")

func _process(_delta):
	if(_client.CONNECTION_CONNECTED):
		_client.poll()
		_serv_connection()

func _get_data():
	var pck = JSON.parse(_client.get_peer(1).get_packet().get_string_from_utf8())
	var error = pck.get_error()
	if(error != 0):
		_client.disconnect_from_host(400, "Wrong package.")
		return 1
	else:
		var pkg = pck.result
		return pkg

onready var package_manager = load("res://networking/client_package_manager.gd")

func _data():
	_update_ping()
	var data = _get_data()
	package_manager._package_manager(data)
