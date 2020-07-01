extends Node2D

onready var time = OS.get_system_time_msecs()
onready var time2 = OS.get_system_time_secs()
var boot = 0
var SFX = false
var rng = RandomNumberGenerator.new()
var random = 0
var v1 = 0
onready var time3 = OS.get_system_time_secs()
func _ready():
	rng.randomize()
	get_node("mapstart").visible = false
	get_node("player").visible = false
	get_node("map").visible = false
	get_node("map").clear = true
	get_node("map").generate = false
	set_process(true)
	set_process_input(true)
	get_node("fog").visible = false
	get_node("fog").set_process(false)
	
func _process(delta):
	if(get_node("Control/play").pressed):
		get_node("map").clear = false
		get_node("Control").visible = false
		get_node("Control").set_process(false)
		get_node("Control").set_process_input(false)
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
			get_node("mapstart").visible = true
			get_node("player").visible = true
			get_node("player").set_process(true)
			get_node("player").set_process_input(true)
			get_node("player").set_physics_process(true)
			get_node("fog").visible = true
			get_node("fog").set_process(true)
			boot = 0
			SFX = true
	if(boot == 0):
		time = OS.get_system_time_msecs()
		get_node("Loading").visible = false
	#get_node("Area2D").position.x = get_node("player").position.x - 500
	if(SFX == true):
		if(OS.get_system_time_secs() - time2 > 10):
			random = rng.randf_range(1, 6)
			if(random == 3):
				get_node("SFX").play()
			if(random == 4):
				get_node("SFX2").play()
			if(random == 2):
				get_node("SFX3").play()
			time2 = OS.get_system_time_secs()
			
	get_node("fog").x = get_node("player").position.x
		
		
		
	
