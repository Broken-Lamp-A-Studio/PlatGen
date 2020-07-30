extends Sprite
var rng = RandomNumberGenerator.new()
onready var last_time = OS.get_system_time_msecs()

func move_cloud():
	self.offset.x += 1
func _ready():
	rng.randomize()
	set_process(false)
func _process(delta):
	if(OS.get_system_time_msecs() - last_time > 100):
		move_cloud()
		last_time = OS.get_system_time_msecs()
	if(self.offset.x > 300):
		cloud()
		
func cloud():
	self.visible = false
	self.offset.x = -5
	var random = rng.randf_range(0, 50)
	self.offset.y = random
	self.visible = true
