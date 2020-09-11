extends Sprite

onready var wait = OS.get_system_time_secs()
onready var time1 = OS.get_system_time_msecs()

func _ready():
	self.modulate.a = 1
	set_process(true)
	self.visible = true
	
func _process(delta):
	print(self.modulate.a)
	if(OS.get_system_time_secs() - wait > 3):
		if(OS.get_system_time_msecs() - time1 > 50):
			self.modulate.a -= 0.05
			time1 = OS.get_system_time_msecs()
	else:
		time1 = OS.get_system_time_msecs()
