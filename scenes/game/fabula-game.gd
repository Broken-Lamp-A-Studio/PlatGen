extends Node2D

onready var time3 = OS.get_system_time_secs()
onready var time = OS.get_system_time_secs()
var x = 0
var f = File.new()
var n = "res://saved/worlds"+"obj%d" % OS.get_system_time_secs()
var mouse = 1

func _ready():
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

