extends Node2D

var x = 0
var mouse = 1
onready var time3 = OS.get_system_time_secs()
onready var time = OS.get_system_time_secs()
func _ready():
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
	if(OS.get_system_time_secs() - time > 4):
		get_node("map").generate = false
		get_node("star").spawn = true
		get_node("star").position.x = 0
		get_node("star").position.y = get_node("map").random3
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
		
