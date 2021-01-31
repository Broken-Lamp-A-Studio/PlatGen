extends Node2D

var unvisible_all = 0
onready var a_time = OS.get_system_time_msecs()
var b = 0
func animation():
	if(OS.get_system_time_msecs() - a_time > 250):
		if(b == 0):
			get_node("animation").texture = load("res://textures/animation-1.png")
			b = 1
		elif(b == 1):
			get_node("animation").texture = load("res://textures/animation-2.png")
			b = 0
		a_time = OS.get_system_time_msecs()
var progress = 0
func loading():
	get_node("loading/loading").position.x = -1000+progress*10
func _process(delta):
	if(unvisible_all == 0):
		animation()
		loading()
	elif(unvisible_all == 1):
		anim2()
	elif(unvisible_all == 2):
		set_process(false)
		
onready var t_time = OS.get_system_time_msecs()
func test():
	if(OS.get_system_time_msecs() - t_time > 100):
		progress += 1
		if(progress == 100):
			progress = 0
			
		t_time = OS.get_system_time_msecs()
func change_progress(information, type, progress2):
	get_node("loading/information").text = information
	if(type == "+"):
		progress += progress2
	elif(type == "set"):
		progress = progress2
	elif(type == "-"):
		progress -= progress2
func _ready():
	get_node("background").modulate.a = 1
	get_node("loading").visible = true
	get_node("animation").visible = true
	get_node("logo").visible = true
	self.visible = true
	get_node("Light2D").enabled = true
	set_process(true)

func unvisible():
	get_node("loading").visible = false
	get_node("animation").visible = false
	get_node("logo").visible = false
	get_node("Light2D").enabled = false
	progress = 0
	unvisible_all = 1
onready var time1 = OS.get_system_time_msecs()
func anim2():
	if(OS.get_system_time_msecs() - time1 > 50):
		if not(get_node("background").modulate.a == 0):
			get_node("background").modulate.a -= 0.05
		else:
			self.visible = false
			unvisible_all = 2
			
		time1 = OS.get_system_time_msecs()
func visible2():
	unvisible_all = 0
	get_node("loading").visible = true
	get_node("animation").visible = true
	get_node("logo").visible = true
	get_node("background").modulate.a = 1
	self.visible = true
	get_node("Light2D").enabled = true
	set_process(true)

func get_stop():
	set_process(false)
	set_process_input(false)
	set_physics_process(false)

func get_play():
	set_process(true)
	set_process_input(true)
	set_physics_process(true)
