extends Node2D

var spawn = false
onready var time = OS.get_system_time_msecs()
var zmienna = 0
var y = self.position.y

func _ready():
	self.visible = false
	zmienna = 1
	set_process(true)
	
func _process(delta):
	if(spawn == true):
		self.visible = true
	
	
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
