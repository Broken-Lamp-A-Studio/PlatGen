extends Camera2D


var x = 0
func _ready():
	set_process(false)
	
func _process(delta):
	self.position.x = x
	self.position.y = 50
