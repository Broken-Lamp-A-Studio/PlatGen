extends Control

var sa = true
onready var time = OS.get_system_time_msecs()
func _ready():
	self.modulate.a = 0
func _process(delta):
	if(get_tree().get_root().get_node("Menu2/Camera2D/Startanimation").visible == false and sa == true):
		animationstart()
func animationstart():
	if(OS.get_system_time_msecs() - time > 50):
		self.modulate.a += 0.05
		
		time = OS.get_system_time_msecs()
		if(self.modulate.a >= 1):
			sa = false
