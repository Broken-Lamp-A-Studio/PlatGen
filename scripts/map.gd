extends Node2D
const map2 = preload("res://scenes/Maploader.tscn")
const pleft = preload("res://scenes/physics_scenes/physicsleft.tscn")
const pright = preload("res://scenes/physics_scenes/physicsright.tscn")
const pup = preload("res://scenes/physics_scenes/physicsup.tscn")
const pdown = preload("res://scenes/physics_scenes/physicsdown.tscn")
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
var childscount2 = 1
var random2 = 0
var random3 = 20
var cc2 = "0"
var childpath2 = "0"
var cc3 = "0"
var shape = RectangleShape2D.new()
var PlatformSize = 10
var childn3 = "0"
var downc = [downc]
var upc = [upc]
var rightc = [rightc]
var leftc = [ ]
var y2 = 0
var s2 = 1

func _ready():
	
	rng.randomize()
	set_process(true)
var map3 = map2.instance()
func _process(_delta):
	if(s2 == 1):
		random3 += 400
		random2 = -50
		s2 = 0
	if(generate == true and clear == false):
		childscount2 += 1
		childname = "obj%d" % childscount2
		childlist = [childlist, childname ]
		print(childname)
		cc = map2.instance()
		cc.name = childname
		self.add_child(cc)
		get_node(childname).visible = true
		random2 += rng.randf_range(50, 60)
		
		random3 = rng.randf_range(30, 100)
		print(random3)
		childname2 = childname+"/dirt"
		get_node(childname2).position.x = random2
		get_node(childname2).position.y = random3
		childname2 = childname+"/cobble"
		get_node(childname2).position.x = random2
		get_node(childname2).position.y = random3+50
		childname2 = childname+"/ss"
		get_node(childname2).position.x = random2
		get_node(childname2).position.y = random3+25
		childname2 = childname+"/ss2"
		get_node(childname2).position.x = random2
		get_node(childname2).position.y = random3+25
		childname2 = childname+"/ss3/s1"
		get_node(childname2).position.x = random2
		get_node(childname2).position.y = random3+26
		childname2 = childname+"/ss4/s2"
		get_node(childname2).position.x = random2
		get_node(childname2).position.y = random3+29
		
		
		
	if(childscount >= 10):
		get_node("playerengine").visible = true
		get_node("playerengine").set_process(true)
		get_node("playerengine").set_process_input(true)
		set_process(false)
	if(clear == true):
		random2 = 30
		random3 = 30
		pass
		
func setupfirst():
	get_node(childname).texture = load("res://textures/mapgen.png")
	random2 = rng.randf_range(0, 1000)
	random3 = rng.randf_range(0, 500)
	get_node(childname).position.x = random2
	get_node(childname).position.y = random3
	get_node(childname).scale.x = 5
	get_node(childname).scale.y = 5
	get_node(childname).visible = true
	
