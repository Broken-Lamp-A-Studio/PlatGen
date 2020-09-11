extends Sprite


var type = "opened"

func _ready():
	set_process(true)
	
func _process(delta):
	if(type == "closed"):
		closed()
	elif(type == "opened"):
		opened()
	
func opened():
	self.position.x = -57.543
	self.position.y = 121.039

func closed():
	self.position.x = -57.543
	self.position.y = 87.307
