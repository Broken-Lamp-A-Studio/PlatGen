extends Sprite

var run = true
onready var time2 = OS.get_system_time_msecs()


func _ready():
	self.visible = true
	self.self_modulate.a = 1
	set_process(true)
	
func _process(delta):
	if(OS.get_system_time_msecs() - time2 > 50 and run == true):
		self.self_modulate.a -= 0.05
		time2 = OS.get_system_time_msecs()
	if(self.self_modulate.a <= 0):
		self.visible = false
		run = false
		set_process(false)
		
