extends Node2D

onready var time3 = OS.get_system_time_secs()
onready var time = OS.get_system_time_secs()
var x = 0
var n = "res://saved/worlds"+"obj%d" % OS.get_system_time_secs()
var mouse = 1
var t = false
var load_data = File.new()
var data = "res://data/main.json"
var mode = "Easy"
var render_time = 3
var type2 = "default"
var node_data = 0
func _ready():
	start("res://data/main.json")
	if(mode == "Easy"):
		render_time = 3
	elif(mode == "Normal"):
		render_time = 6
	elif(mode == "Hard"):
		render_time = 10
	
	get_node("map").set_process(true)
	get_node("map").generate = true
	get_node("map").visible = true
	get_node("player/Camera2D").visible = true
	get_node("player").visible = true
	get_node("player").set_process(true)
	get_node("player").set_process_input(true)
	get_node("player").set_physics_process(true)
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process(true)

func _process(delta):
	get_node("TileMap").multix = get_node("player").position.x
	get_node("TileMap").multiy = get_node("player").position.y
	get_node("LightMouse").x = get_node("player").position.x
	get_node("LightMouse").y = get_node("player").position.y
	if(t == false and OS.get_system_time_secs() - time > render_time):
		get_node("map").generate = false
		get_node("star").position.y = get_node("map").random3-200
		get_node("star").position.x = 50
		print("Star X:%d"%get_node("star").position.x)
		print("Star Y:%d"%get_node("star").position.y)
		t = true
		
	if(Input.is_action_just_pressed("ui_cancel")):
		if(mouse == 0):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse = 1
		elif(mouse == 1):
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			mouse = 0
	
func render(direction):
	if(direction == 1):
		x = 50
		
		
func start(ata):
	load_data.open(ata, File.READ)
	var node_data2 = parse_json(load_data.get_line())

	if(node_data2.type == "default"):
		mode = node_data2.mode
	else:
		mode = "Easy"
	print("Mode:"+mode)
	load_data.close()
