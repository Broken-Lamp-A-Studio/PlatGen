extends Button

func read_dir(path):
	var dir = Directory.new()
	var type = false
	if(dir.dir_exists(path)):
		type = true
	else:
		type = false
	return type
func make_dir(path):
	var dir = Directory.new()
	if not(read_dir(path)):
		dir.make_dir(path)
func make_file(path, data, type):
	var file = File.new()
	file.open(path, File.WRITE)
	if(type == "normal"):
		file.store_line(data)
	elif(type == "json"):
		var json_data = parse_json(data)
		file.store_line(to_json(json_data))
	file.close()
func read_file(path, type):
	var file = File.new()
	var dir = Directory.new()
	if(dir.file_exists(path)):
		file.open(path, File.READ)
		if(type == "normal"):
			return file.get_line()
		elif(type == "json"):
			return parse_json(file.get_as_text())
		file.close()
	else:
		return null
func _ready():
	pass
	#OS.window_fullscreen = get_tree().get_root().get_node("Menu2").config.fullscreen
onready var time = OS.get_system_time_msecs()

func _process(delta):
	if(self.pressed and OS.get_system_time_msecs() - time > 300):
		if(get_tree().get_root().get_node("Menu2").config.fullscreen == false):
			get_tree().get_root().get_node("Menu2").config.fullscreen = true
			OS.window_fullscreen = true
		elif(get_tree().get_root().get_node("Menu2").config.fullscreen == true):
			get_tree().get_root().get_node("Menu2").config.fullscreen = false
			OS.window_fullscreen = false
		time = OS.get_system_time_msecs()
func display():
	if(get_tree().get_root().get_node("Menu2").config.fullscreen == true):
		self.text = "Mouse: From game"
	else:
		self.text = "Mouse: From OS"
