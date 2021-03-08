extends AudioStreamPlayer

onready var time = OS.get_system_time_msecs()
var volume_type = 0
var music = [{"type":"buildin", "path":"res://sounds/soundtracks/full/soundtrack-22.ogg"}]

func music_scan():
	pass

func volume_up():
	if not(volume_db >= 0):
		volume_db += 10
	else:
		volume_type = 0

func volume_down():
	if not(volume_db <= -80):
		volume_db -= 10
	else:
		volume_type = 0

func volume_process():
	if(OS.get_system_time_msecs() - time > 10):
		if(volume_type == 1):
			volume_up()
		elif(volume_type == 2):
			volume_down()
		time = OS.get_system_time_msecs()

var rng = RandomNumberGenerator.new()

func play_random():
	var random = round(rng.randf_range(0, music.size()-1))
	if(music[random].type == "builtin"):
		var data = AudioStreamOGGVorbis.new()
		data.resource_path = load(music[random].path)
		stream = data
		play()
		volume_type = 1

func _ready():
	rng.randomize()

func _process(_delta):
	volume_process()
	stream_process()

onready var time2 = OS.get_system_time_secs()
var dynamic1 = 0
var random2 = 10
func stream_process():
	if(dynamic1 == 0):
		random2 = round(rng.randf_range(10, 100))
		dynamic1 = 1
	if(dynamic1 == 1):
		if(volume_db == -80):
			volume_type = 1
			play_random()
			dynamic1 = 2
	if(dynamic1 == 2):
		if(OS.get_system_time_secs() - time2 > random2):
			time2 = OS.get_system_time_secs()
			volume_type = 2
			dynamic1 = 3
	if(dynamic1 == 3):
		if(volume_db == -80):
			dynamic1 = 0
