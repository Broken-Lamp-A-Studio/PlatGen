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
var childscount2 = "2"
var random2 = 30
var random3 = 30
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

func _ready():
	
	rng.randomize()
	set_process(true)
var map3 = map2.instance()
func _process(_delta):
	
	if(generate == true and clear == false):
		childname = childname+childscount2
		childlist = [childlist, childname ]
		print(childname)
		cc = map2.instance()
		cc.name = childname
		self.add_child(cc)
		get_node(childname).visible = true
		random2 = rng.randf_range(0, 1000)
		random3 = rng.randf_range(0, 1000)
		childname2 = childname+"/dirt"
		get_node(childname2).position.x = random2
		get_node(childname2).position.y = random3
		childname2 = childname+"/cobble"
		get_node(childname2).position.x = random2
		get_node(childname2).position.y = random3+50
		childname2 = childname+"/ss"
		get_node(childname2).position.x = random2
		get_node(childname2).position.y = random3+25
		#cc2 = pleft.instance()
		#childn3 = childname+"left"
		#cc2.name = childn3
		#self.add_child(cc2)
		#childn3 = childname+"left"+"/StaticBody2D"
		#leftc = [leftc, childn3 ]
		#get_node(childn3).position.x = random2
		#get_node(childn3).position.y = random3
		#cc2 = pright.instance()
		#childn3 = childname+"right"
		#cc2.name = childn3
		#self.add_child(cc2)
		#childn3 = childname+"right"+"/StaticBody2D"
		#rightc = [rightc, childn3 ]
		#get_node(childn3).position.x = random2
		#get_node(childn3).position.y = random3
		#cc2 = pup.instance()
		#childn3 = childname+"up"
		#cc2.name = childn3
		#self.add_child(cc2)
		#childn3 = childname+"up"+"/StaticBody2D"
		#upc = [upc, childn3 ]
		#get_node(childn3).position.x = random2
		#get_node(childn3).position.y = random3
		#cc2 = pdown.instance()
		#childn3 = childname+"down"
		#cc2.name = childn3
		#self.add_child(cc2)
		#childn3 = childname+"down"+"/StaticBody2D"
		#downc = [downc, childn3 ]
		#get_node(childn3).position.x = random2
		#get_node(childn3).position.y = random3

		
		
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
	
