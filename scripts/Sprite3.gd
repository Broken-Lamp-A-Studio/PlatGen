extends Sprite
var rng = RandomNumberGenerator.new()
onready var last_time = OS.get_system_time_secs()

func move_cloud():
	self.offset.x += 1
func _ready():
	rng.randomize()
	set_process(true)
func _process(delta):
	if(OS.get_system_time_secs() - last_time > 0.1):
		move_cloud()
		last_time = OS.get_system_time_secs()
	if(self.offset.x > 300):
		cloud()
		
func cloud():
	self.visible = false
	self.offset.x = -57
	var random = rng.randf_range(0, 100)
	self.offset.y = random
	self.visible = true
