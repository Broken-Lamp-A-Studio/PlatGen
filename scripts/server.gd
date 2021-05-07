extends Node

onready var console_output = get_node("/root/MainSymlink")
var server_data_config = {}
onready var ports = get_node("/root/ServerWebsocketPorts")
var websocket = WebSocketServer.new()

func check_ports():
	var tick = 0
	var check = websocket.listen(ports.min_search_port)
	while(tick <= ports.max_search_port and check != OK):
		tick += 1
		check = websocket.listen(ports.min_search_port+tick)
	if(check != OK):
		console_output.console_output("Failed to listen server between %d"%ports.min_search_port+" - %d"%ports.max_search_port+" ports. Error output: "+check, "err")
		console_output.console_output("Closing server...", "err")
		self.queue_free()
		return null
	else:
		console_output.console_output("Listen server port founded - %d"%(ports.min_search_port+tick), "info")
		return {"port":(ports.min_search_port+tick), "check_result":check}

func _ready():
	websocket.connect("client_connected", self, "_client_connected")
	websocket.connect("client_disconnected", self, "_client_disconnected")
	websocket.connect("client_close_request", self, "_client_close_request")
	websocket.connect("connection_failed", self, "_connection_failed")
	websocket.connect("connection_succeeded", self, "_connection_secceeded")
	websocket.connect("server_disconnected", self, "_srever_disconnected")
	websocket.connect("peer_packet", self, "_peer_packet")
	websocket.connect("peer_disconnected", self, "_peer_disconnected")
	websocket.connect("peer_connected", self, "_peer_connected")
	var result = check_ports()
	server_data_config.port = result.port
	server_data_config.check_result = result.check_result
	
	get_node("/root/ClientWebsocketPorts").local_server_port = result.port

func _process(_delta):
	if(server_data_config.check_result == OK):
		websocket.poll()

