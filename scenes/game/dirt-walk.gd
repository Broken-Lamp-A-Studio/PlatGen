extends AudioStreamPlayer

var rng = RandomNumberGenerator.new()
var pla = false
var random = 0
onready var time = OS.get_system_time_secs()
onready var time2 = OS.get_system_time_msecs()
var path = 0

func _ready():
	rng.randomize()
	self.stream_paused = true
	self.autoplay = false
	self.playing = false
	set_process(true)
	
func _process(delta):
	if(pla == true and OS.get_system_time_secs() - time > 1):
		random = rng.randf_range(1, 15)
		path = "res://sounds/dirt-walk/sounds/%d"%random
		path += ".ogg"
		self.stream = load(path)
		self.stream_paused = false
		self.play(1)
		time = OS.get_system_time_secs()
	if(pla == false):
		self.stream_paused = true
		self.stop()
