extends VideoPlayer

var dir = Directory.new()
onready var time = OS.get_system_time_secs()

func _ready():
	dir.open("user://")
	if not(dir.dir_exists("user://PlatGen")):
		dir.make_dir("user://PlatGen")
	if not(dir.dir_exists("user://PlatGen/logs")):
		dir.make_dir("user://PlatGen/logs")
	if not(dir.dir_exists("user://PlatGen/save")):
		dir.make_dir("user://PlatGen/save")
	if not(dir.dir_exists("user://PlatGen/user-settings")):
		dir.make_dir("user://PlatGen/user-settings")
	self.visible = true
	set_process(true)
	set_process_input(true)
func _process(delta):
	if(OS.get_system_time_secs() - time > 18 or Input.is_key_pressed(KEY_ESCAPE)):
		self.visible = false
		get_tree().change_scene("res://scenes/Menu.tscn")
