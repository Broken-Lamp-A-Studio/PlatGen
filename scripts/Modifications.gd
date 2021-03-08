extends Node

const lib = preload("res://libs/main.gd")
var modlist = []
var modscripts = []

func load_mod(path):
	var info = load(path+"/config.tres")
	modlist += [info]
	load_script(path+"/"+info.main)

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
