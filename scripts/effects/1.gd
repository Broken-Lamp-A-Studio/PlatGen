extends AudioStreamPlayer2D

onready var time = OS.get_system_time_secs()
var rng = RandomNumberGenerator.new()
var random = 0
onready var time2 = OS.get_system_time_msecs()
var p = 1

func _ready():
	rng.randomize()
	random = rng.randf_range(1, 10)
	set_process(true)
	
	
func _process(delta):
	if(p == 1 and OS.get_system_time_secs() - time > random):
		random = rng.randf_range(1, 10)
		play()
		time = OS.get_system_time_secs()
		p = 2
		time2 = OS.get_system_time_msecs()
	if(p == 2 and OS.get_system_time_msecs() - time2 > 500):
		stop()
		p = 1
		time = OS.get_system_time_secs()


	
