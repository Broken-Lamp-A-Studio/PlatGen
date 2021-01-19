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

var active = true
func _ready():
	pass
	#active = get_tree().get_root().get_node("Menu2").game_mouse
onready var time = OS.get_system_time_msecs()
func _process(delta):
	display()
	if(self.pressed and OS.get_system_time_msecs() - time > 300):
		active = not active
		get_tree().get_root().get_node("Menu2").config.game_mouse = active
		time = OS.get_system_time_msecs()
func display():
	if(active == true):
		self.text = "Mouse: From game"
	else:
		self.text = "Mouse: From OS"
