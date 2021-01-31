extends VideoPlayer

###CONFIG###
var version = "0.50"
var author = "GamePlayer"
var devs = ["GamePlayer"]
############

var dir = Directory.new()
onready var time = OS.get_system_time_secs()
var size
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	print("===OS informations===")
	print("OS:"+OS.get_name())
	print("Audio: %d"%OS.get_audio_driver_count())
	print("Graphics: %d"%OS.get_current_video_driver())
	print("Executable path: "+OS.get_executable_path())
	print("Working path: "+OS.get_user_data_dir())
	print("Game name: PlatGen")
	print("Version: "+version)
	print("Authors:")
	print(devs)
	print("===END===")
	print("Starting game...")
	dir.open("user://")
	if not(dir.dir_exists("user://logs")):
		dir.make_dir("user://logs")
	if not(dir.dir_exists("user:///save")):
		dir.make_dir("user:///save")
	if not(dir.dir_exists("user://user-settings")):
		dir.make_dir("user:///user-settings")
	self.visible = true
	set_process(true)
	set_process_input(true)
var s2 = 0
func _process(delta):
	size = stream_position
	if(s2 < size):
		s2 += 1
		print("Countdown to start: %d"%(25-s2))
	#elif(s2 > size):
	#	get_tree().change_scene("res://scenes/Menu.tscn")
	if(OS.get_system_time_secs() - time > 25 or Input.is_key_pressed(KEY_ESCAPE)):
		if(Input.is_key_pressed(KEY_ESCAPE)):
			print("Countdown canceled...")
		print("Running game!")
		#self.visible = false
		get_tree().change_scene("res://scenes/Menu2.tscn")
