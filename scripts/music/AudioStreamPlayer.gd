extends AudioStreamPlayer

var music = true

func _ready():
	self.autoplay = true
	self.playing = true
	self.stream_paused = false
	set_process(true)
	set_process_input(true)
	
func _process(delta):
	if(Input.is_action_just_pressed("ui_music")):
		if(music == true):
			self.stream_paused = true
			music = false
		elif(music == false):
			self.stream_paused = false
			music = true
