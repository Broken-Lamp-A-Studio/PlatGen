extends Light2D


onready var msec = OS.get_system_time_msecs()
var light = 0.5
var type = 1
func _ready():
	set_process(true)
	
func _process(delta):
	self.scale.x = light
	self.scale.y = light
	if(OS.get_system_time_msecs() - msec > 50):
		if(type == 1):
			light -= 0.01
			if(light <= 0.1):
				type = 2
		elif(type == 2):
			light += 0.01
			if(light >= 0.5):
				type = 1
		msec = OS.get_system_time_msecs()
