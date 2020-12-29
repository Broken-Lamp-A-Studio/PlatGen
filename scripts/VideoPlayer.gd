extends VideoPlayer

var dir = Directory.new()
onready var time = OS.get_system_time_secs()
var size
func _ready():

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
		print(s2)
	#elif(s2 > size):
	#	get_tree().change_scene("res://scenes/Menu.tscn")
	if(OS.get_system_time_secs() - time > 25 or Input.is_key_pressed(KEY_ESCAPE)):
		self.visible = false
		get_tree().change_scene("res://scenes/Menu.tscn")
