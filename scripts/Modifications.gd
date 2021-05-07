extends Node

const lib = preload("res://libs/main.gd")
var modlist = []
var modscripts = []

func load_mod(path):
	var mod = rdfile(path, "var")
	

func load_script(path):
	var data = GDScript.new()
	data.source_code = load(path)
	var node = Node.new()
	node.name = path
	modscripts += [node.name]
	self.add_child(node)
	get_node(path).set_script(data)

func _ready():
	load_mod("res://base")

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
