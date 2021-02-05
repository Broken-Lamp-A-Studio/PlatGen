extends Sprite

var s = 0
onready var time = OS.get_system_time_msecs()
func _ready():
	self.modulate.a = 1
	self.visible = true
func animation():
	if(OS.get_system_time_msecs() - time > 50):
		self.modulate.a -= 0.05
		s += 0.05
		time = OS.get_system_time_msecs()
		if(self.modulate.a <= 0):
			self.visible = false
			self.modulate.a = 1
func _process(_delta):
	if(self.visible == true):
		animation()
