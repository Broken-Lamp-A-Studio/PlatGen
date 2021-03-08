extends Control

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

func read_file(path):
	var file = File.new()
	file.open(path, File.READ)
	var data = file.get_line()
	file.close()
	return data

func theme2(path_alias):
	if(path_alias.get_extension() == "alias"):
		self.theme = load(read_file(path_alias))
	else:
		self.theme = load(path_alias)

func set_pos(x, y, h, w):
	$ItemList.rect_position.x = x
	$ItemList.rect_position.y = y
	$ItemList.rect_size.x = h
	$ItemList.rect_size.y = w

func initialize_mod(path):
	pass
