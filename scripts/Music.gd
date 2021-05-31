extends AudioStreamPlayer

var rng = RandomNumberGenerator.new()
var music = []

func _ready():
	set_process(false)
	rng.randomize()
	

func _process(_delta):
	_music_process()

func set_music(array_path = []):
	music = array_path
	if(stream != null):
		play_music(rng.randf_range(0, music.size()-1))

var pos2 = 0

func play_music(pos):
	pos2 = pos
	$volume.play("Volume down")

func _on_volume_next():
	stop()
	if(lib_main.check(music[pos2])):
		self.stream = load(music[pos2])
		play()
		$volume.play("Volume up")


func _on_volume_f(anim_name):
	if(anim_name == "Volume down"):
		_on_volume_next()

func _music_process():
	if(stream == null and music.size() > 0):
		play_music(rng.randf_range(0, music.size()-1))
	if(stream != null and stream.get_length() >= get_playback_position() and stream.get_length() <= get_playback_position()+0.4 and music.size() > 1):
		
		play_music(rng.randf_range(0, music.size()-1))
