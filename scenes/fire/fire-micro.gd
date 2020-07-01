extends Node2D

onready var time = OS.get_system_time_msecs()
var rng = RandomNumberGenerator.new()
var clonename = "particle"
var clonecount2 = 1
var color = 1
var random = 0
var active = 1
var clonetype = Sprite.new()
var actualclone = ""
var clonelist = ""
var texture2 = ""
var defx = 0
var defy = 0

func _ready():
	rng.randomize()

func _process(_delta):
	if(active == 1):
		if(OS.get_system_time_msecs() - time > 200):
			clonecount2 += 1
			clonename = "obj2%d" % clonecount2
			clonelist = [clonelist, clonename]
			clonetype.name = clonename
			self.add_child(clonetype)
			random = rng.randf_range(1, 4)
			if(random == 1):
				texture2 = "res://textures/fire/micro/red.png"
			if(random == 2):
				texture2 = "res://textures/fire/micro/yellow.png"
			if(random == 3):
				texture2 = "res://textures/fire/micro/black.png"
			if(random == 4):
				texture2 = "res://textures/fire/micro/orange.png"
			get_node(clonename).texture = load(texture2)
			random = rng.randf_range(1, 3)
			get_node(clonename).scale.x = random
			random = rng.randf_range(1, 3)
			get_node(clonename).scale.y = random
			get_node(clonename).position.x = defx
			get_node(clonename).position.y = defy
			get_node(clonename).set_script(load("res://scenes/fire/Fire-micro2.gd"))
			time = OS.get_system_time_msecs()
