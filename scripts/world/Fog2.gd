extends Sprite


var rng = RandomNumberGenerator.new()
onready var msec = OS.get_system_time_msecs()
var random = 0
var costium = 0
var x = 0
var y = 0
func _ready():
	rng.randomize()
	
func _process(delta):
	print(self.name)
	print(self.position.x)
	print(self.position.y)
	if(OS.get_system_time_msecs() - msec > 100):
		self.position.x += 1
		msec = OS.get_system_time_msecs()
	if(self.position.x > x+50):
		self.position.x = x-100
		random = rng.randf_range(50, 100)
		self.position.y = y+random
		random = rng.randf_range(1, 4)
		costium = "res://textures/fog/%d" % random
		costium += ".png"
		self.texture = costium

func go(x2, y2):
	x = x2
	y = y2
	self.position.x = x2-100
	random = rng.randf_range(50, 100)
	self.position.y = y2+random
	random = rng.randf_range(1, 4)
	costium = "res://textures/fog/%d" % random
	costium += ".png"
	self.texture = costium
	self.visible = true
