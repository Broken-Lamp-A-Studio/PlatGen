extends Sprite
var rng = RandomNumberGenerator.new()
var random = 0
onready var time = OS.get_system_time_msecs()
onready var time2 = OS.get_system_time_secs()
var x = self.position.x
var y = self.position.y
func _ready():
	set_process(true)
	self.visible = true
	rng.randomize()
	random = rng.randf_range(1, 5)
	

func _process(_delta):
	if(OS.get_system_time_msecs() - time > 50):
		self.position.x += rng.randf_range(-1.00, 1.00)
		self.position.y += -1
		self.rotate(rng.randf_range(-1.00, 1.00))
		time = OS.get_system_time_msecs()
	if(OS.get_system_time_secs() - time2 > random):
		self.visible = false
		self.position.x = x
		self.position.y = y
		self.visible = true
		time2 = OS.get_system_time_secs()
		random = rng.randf_range(1, 5)
	
