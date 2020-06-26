extends Node2D

onready var time = OS.get_system_time_msecs()
var boot = 0
func _ready():
	get_node("player").visible = false
	get_node("map").visible = false
	get_node("map").clear = true
	get_node("map").generate = false
	set_process(true)
	set_process_input(true)
	
func _process(delta):
	if(get_node("Control/play").pressed):
		get_node("map").clear = false
		get_node("Control").visible = false
		get_node("Control").set_process(false)
		get_node("Control").set_process_input(false)
		get_node("Area2D/mapdefault").visible = true
		get_node("Loading").visible = true
		boot = 1
	if(boot == 1):
		get_node("Loading").visible = true
		get_node("map").set_process(true)
		get_node("map").generate = true
		if(OS.get_system_time_msecs() - time > 500):
			get_node("map").generate = false
			print(get_node("map").upc)
			print(get_node("map").downc)
			print(get_node("map").rightc)
			print(get_node("map").leftc)
			get_node("map").set_process(false)
			get_node("map").visible = true
			get_node("player").visible = true
			get_node("player").set_process(true)
			get_node("player").set_process_input(true)
			boot = 0
	if(boot == 0):
		time = OS.get_system_time_msecs()
		get_node("Loading").visible = false
		
	
		
		
		
		
	
