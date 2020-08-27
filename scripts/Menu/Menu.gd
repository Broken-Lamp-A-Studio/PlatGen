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
	print("test")
	self.visible = true
	rng.randomize()
	set_process(true)
	set_process_input(true)
	
func _process(delta):
	if(get_node("Menu/play").pressed):
		get_tree().change_scene("res://scenes/menus/choose-game.tscn")




	
		
		
		
	
