extends Sprite


var damaged = false

func _ready():
	set_process(true)
	
func _process(delta):
	if(damaged == false):
		self.texture = load("res://textures/intro/base/background.png")
	elif(damaged == true):
		self.texture = load("res://textures/intro/base/background-broke.png")
		
