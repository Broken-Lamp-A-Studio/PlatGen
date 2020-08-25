extends AudioStreamPlayer

onready var time1 = OS.get_system_time_secs()
var rng = RandomNumberGenerator.new()
var random = 0
onready var time2 = OS.get_system_time_msecs()
var a = 0

func _ready():
	rng.randomize()
	random = rng.randf_range(8, 15)
	set_process(true)
	
	
func _process(delta):
	if(a == 0 and OS.get_system_time_secs() - time1 > random):
		self.play()
		random = rng.randf_range(8, 15)
		time1 = OS.get_system_time_secs()
		time2 = OS.get_system_time_msecs()
		a = 1
	if(a == 1 and OS.get_system_time_msecs() - time2 > 600):
		a = 0
		self.stop()
		time2 = OS.get_system_time_msecs()
		time1 = OS.get_system_time_secs()
