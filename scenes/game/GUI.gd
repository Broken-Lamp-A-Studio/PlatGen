extends Control


onready var time = OS.get_system_time_secs()
var finish = 0
var o = 0
var respawn = false
var best = 0

func _ready():
	o = 0
	finish = false
	set_process(true)
	
func _process(delta):
	get_node("Label").text = "Game Time: %d"%o
	get_node("Label2").text = "Best Time: %d"%best
	if not(finish == true):
		o = OS.get_system_time_secs()-time
		
	if(finish == true):
		if(o>best):
			best = o
		o = 0
		time = OS.get_system_time_secs()
	
	
	if(respawn == true):
		o = 0
		time = OS.get_system_time_secs()
