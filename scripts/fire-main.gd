extends Node2D

onready var time3 = OS.get_system_time_msecs()
onready var time2 = OS.get_system_time_msecs()
onready var time = OS.get_system_time_msecs()
var rng = RandomNumberGenerator.new()
var random = 0
var type = 1
func _ready():
	rng.randomize()

func _process(delta):
	if(OS.get_system_time_msecs() - time > 100):
		if(type == 1):
			type = 2
		elif(type == 2):
			type = 3
		elif(type == 3):
			type = 1
		time = OS.get_system_time_msecs()
	if(type == 1):
		get_node("Sprite").visible = true
		get_node("Sprite2").visible = false
		get_node("Sprite3").visible = false
	if(type == 2):
		get_node("Sprite").visible = false
		get_node("Sprite2").visible = true
		get_node("Sprite3").visible = false
	if(type == 3):
		get_node("Sprite").visible = false
		get_node("Sprite2").visible = false
		get_node("Sprite3").visible = true
