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
	else:
		file.store_line(data)
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
static func rmdir(path):
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
		dir.remove(path)

static func checkfile(path):
	var dir = Directory.new()
	if(dir.file_exists(path)):
		return true
	else:
		return false




