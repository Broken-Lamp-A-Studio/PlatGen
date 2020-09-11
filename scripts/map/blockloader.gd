extends Node2D

var world = 0
var inv = 0
var dropped = null


func _ready():
	reader()
	
	
	
func reader():
	var file = File.new()
	file.open("res://settings/load.game", File.READ)
	var json_data = parse_json(file.get_line())
	if(json_data.type == "load"):
		world = json_data.world
	file.close()
	file.open("user://PlatGen/save/"+world+"/inv.load", File.READ)
	json_data = parse_json(file.get_line())
	inv.main = json_data.main
	inv.micro = json_data.micro
	file.close()
	file.open("user://PlatGen/save/"+world+"/world.load", File.READ)
	json_data = parse_json(file.get_line())
	world.blocks = json_data.blocks
	world.dropped = json_data.dropped
	world.count = json_data.blockscount
	file.close()
func save():
	var file = File.new()
	
