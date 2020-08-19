extends Node2D


onready var time = OS.get_system_time_msecs()
var zmienna = 0
var y = self.position.y

func _ready():
	zmienna = 1
	set_process(true)
	
func _process(delta):
	
	if(OS.get_system_time_msecs() - time > 100):
		if(zmienna <= 5):
			self.position.y -= 2
			zmienna += 1
		elif(zmienna <= 10):
			self.position.y += 2
			zmienna += 1
		elif(zmienna > 10):
			zmienna = 1
		time = OS.get_system_time_msecs()
