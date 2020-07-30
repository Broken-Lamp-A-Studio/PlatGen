extends Light2D

var x = 0
var y = 0

func _ready():
	set_process(false)
	set_process_input(false)
	
func _input(event):
	if event is InputEventMouseMotion:
		self.position.x = event.position.x+x
		self.position.y = event.position.y+y
func _process(delta):
	print("Pozycja X:"+"%d"%self.position.x)
	print("Pozycja Y:"+"%d"%self.position.y)
