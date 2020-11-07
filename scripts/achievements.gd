extends Node2D

var t = 0
var x
var y
var type2 = 0
onready var time = OS.get_system_time_msecs()

func _ready():
	self.modulate.a = 0
	type2 = 0
	x = self.position.x
	y = self.position.y
	new_achievements("res://textures/ar/i1.png", "test")

func new_achievements(type, name2):
	get_node("icon").texture = load(type)
	get_node("text").text = name2
	t = 1
	type2 = 0
func _process(delta):
	if(t == 1):
		self.visible = true
		if(type2 == 0):
			if(OS.get_system_time_msecs() - time > 10):
				if(self.position.x - x > -100):
					self.position.x -= 5
					self.modulate.a += 0.05
				else:
					type2 = 2
				time = OS.get_system_time_msecs()
		elif(type2 == 2):
			if(OS.get_system_time_msecs() - time > 3000):
				type2 = 1
				time = OS.get_system_time_msecs()
		elif(type2 == 1):
			if(OS.get_system_time_msecs() - time > 10):
				if(self.position.x - x < 100):
					self.position.x += 5
					self.modulate.a -= 0.05
				else:
					type2 = 0
					t = 0
					self.visible = false
				time = OS.get_system_time_msecs()
