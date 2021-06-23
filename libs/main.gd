extends Node


static func mkdir(path):
	var dir = Directory.new()
	if(dir.dir_exists(path)):
		return false
	else:
		dir.make_dir(path)
		return true
static func mkfile(path, type, data):
	var file = File.new()
	file.open(path, File.WRITE)
	if(type == "json"):
		
		file.store_line(to_json(data))
	elif(type == "var"):
		file.store_var(data)
	elif(type == "buffer"):
		file.store_buffer(data)
	elif(type == "string"):
		file.store_string(data)
	elif(type == "real"):
		file.store_real(data)
	elif(type == "script"):
		var gd = GDScript.new()
		gd.set_script(data)
		file.store_line(gd)
	else:
		file.store_line(str(data))
	file.close()
static func rdfile(path, type):
	var data = null
	var file = File.new()
	var dir = Directory.new()
	if(dir.file_exists(path)):
		file.open(path, File.READ)
		if(type == "json"):
			data = parse_json(file.get_line())
		elif(type == "table"):
			data = [parse_json(file.get_line())]
		elif(type == "var"):
			data = file.get_var()
		elif(type == "script"):
			data = file.get_script()
		else:
			data = file.get_as_text()
		file.close()
	return data
static func check(path):
	var dir = Directory.new()
	if(dir.dir_exists(path)):
		return true
	else:
		if(dir.file_exists(path)):
			return true
		else:
			return false
static func ls(path):
	var dir = Directory.new()
	var list = []
	if(!dir.dir_exists(path)):
		return ["null"]
	else:
		dir.open(path)
		dir.list_dir_begin()
		var f = dir.get_next()
		while not(f == ""):
			if not(f == "." or f == ".."):
				list += [f]
			f = dir.get_next()
		return list
static func rmdir(path, rmfolder = true):
	var dir = Directory.new()
	if(dir.dir_exists(path)):
		dir.open(path)
		dir.list_dir_begin()
		var data = dir.get_next()
		while not(data == ""):
			if not(data == "." or data == ".."):
				#print(data)
				if(dir.current_is_dir()):
					rmdir(path+"/"+data)
					dir.remove(path+"/"+data)
				else:
					dir.remove(path+"/"+data)
			data = dir.get_next()
		if(rmfolder):
			dir.remove(path)
		return true
	else:
		return false

static func load_image(path):
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load(path)
	texture.create_from_image(image)
	return texture

static func rmfile(path):
	var dir = Directory.new()
	if(dir.file_exists(path)):
		dir.remove(path)
		return true
	else:
		return false

func generate_time():
	var date = OS.get_datetime()
	var d = str(date["year"])+"."
	if(str(date["month"]).length() == 1):
		d += "0"+str(date["month"])
	else:
		d += str(date["month"])
	d += "."
	if(str(date["day"]).length() == 1):
		d += "0"+str(date["day"])
	else:
		d += str(date["day"])
	d += ":"
	if(str(date["hour"]).length() == 1):
		d += "0"+str(date["hour"])
	else:
		d += str(date["hour"])
	d += "."
	if(str(date["minute"]).length() == 1):
		d += "0"+str(date["minute"])
	else:
		d += str(date["minute"])
	d += "."
	if(str(date["second"]).length() == 1):
		d += "0"+str(date["second"])
	else:
		d += str(date["second"])
	return d

func cp(from_path, to_path, cpfolder = true):
	if(check(from_path)):
		if(check(to_path) == false and cpfolder):
			mkdir(to_path)
		var dir = Directory.new()
		dir.open(from_path)
		dir.list_dir_begin()
		var data = dir.get_next()
		while not(data == ""):
			if not(data == "." or data == ".."):
				if(dir.current_is_dir()):
					cp(from_path+"/"+data, to_path+"/"+data, true)
				else:
					dir.copy(from_path+"/"+data, to_path+"/"+data)
			data = dir.get_next()
		return true
	else:
		return false

func cpfile(from_path, to_path):
	var dir = Directory.new()
	dir.copy(from_path, to_path)


