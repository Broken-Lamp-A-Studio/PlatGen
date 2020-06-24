extends Node2D
const map2 = preload("res://scenes/Maploader.tscn")
var generate = false
var clear = false
var childscount = 0
var childname = "mapgen"
var childname2 = "2mapgen"
var rng = RandomNumberGenerator.new()
var cc = "0"
var random = 0
var childlist = [childlist]
var childlist2 = [childlist2]
var childscount2 = "1"
var random2 = 30
var random3 = 30


func _ready():
	
	rng.randomize()
	set_process(true)
var map3 = map2.instance()
func _process(_delta):
	
	if(generate == true and clear == false):
		childname = childname + childscount2
		map3.name = childname
		print(childname)
		childlist = [childlist, childname]
		self.add_child(map3)
		random2 = rng.randf_range(0, 1000)
		random3 = rng.randf_range(0, 500)
		get_node(childname).posx = random2
		get_node(childname).posy = random3
		get_node(childname).visible = true
		
	if(childscount >= 10):
		get_node("playerengine").visible = true
		get_node("playerengine").set_process(true)
		get_node("playerengine").set_process_input(true)
		set_process(false)
	if(clear == true):
		random2 = 30
		random3 = 30
		pass
	
