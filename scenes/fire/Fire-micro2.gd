extends Sprite
var rng = RandomNumberGenerator.new()
var random = 0
onready var time = OS.get_system_time_msecs()
onready var time2 = OS.get_system_time_secs()
func _ready():
	set_process(true)
	self.visible = true
	rng.randomize()
	random = rng.randf_range(1, 5)
	

func _process(delta):
	if(OS.get_system_time_msecs() - time > 50):
		self.position.x += rng.randf_range(-1.00, 1.00)
		self.position.y += 1
		self.rotate(rng.randf_range(-1.00, 1.00))
		time = OS.get_system_time_msecs()
	if(OS.get_system_time_secs() - time > random):
		self.visible = false
		set_process(false)
	
