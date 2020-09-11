extends Light2D

var type = 1
var tick = false
onready var time = OS.get_system_time_msecs()

func _ready():
	set_process(true)
	self.modulate.a = 1

func tick():
	tick = true
	
func _process(delta):
	if(tick == true):
		if(type == 2 and OS.get_system_time_msecs() - time > 50):
			self.modulate.a += 0.05
			time = OS.get_system_time_msecs()
		if(self.modulate.a >= 1):
			tick = false
			type = 1
		if(type == 1):
			self.modulate.a = 0
			type = 2
			
	elif(tick == false):
		time = OS.get_system_time_msecs()
