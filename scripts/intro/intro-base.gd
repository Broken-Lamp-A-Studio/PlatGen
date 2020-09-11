extends Node2D


var doors = false
var damaged = false

func _ready():
	set_process(true)
	
func _process(delta):
	if(damaged == false):
		get_node("background").damaged = false
		get_node("doors").visible = true
		get_node("lamps/sustain-2").visible = true
	elif(damaged == true):
		get_node("background").damaged = true
		get_node("doors").visible = false
		get_node("lamps/sustain-2").visible = false
	if(doors == false):
		get_node("doors/door-1-1").type = "opened"
		get_node("doors/door-1-1").type = "opened"
	elif(doors == true):
		get_node("doors/door-1-2").type = "closed"
		get_node("doors/door-1-2").type = "closed"
func light():
	get_node("lamps/sustain-1/Light2D").tick()
	get_node("lamps/sustain-2/Light2D2").tick()
