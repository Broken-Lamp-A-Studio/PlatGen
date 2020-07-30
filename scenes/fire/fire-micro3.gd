extends Node2D

onready var time1 = OS.get_system_time_msecs()
var rng = RandomNumberGenerator.new()
var type = 0
var random = 0
var x = 0
var y = 0

func _ready():
	rng.randomize()
	self.visible = false
	self.scale.x = 10
	self.scale.y = 10
	set_process(true)

func _process(delta):
	if(type == 2):
		if(OS.get_system_time_msecs() - time1 > 100):
			self.scale.x -= 0.5
			self.scale.y -= 0.5
			time1 = OS.get_system_time_msecs()
		if(self.scale.x <= 0):
			type = 0
			self.scale.x = 10
			self.scale.y = 10
			self.visible = false
	elif(type == 0):
		random = rng.randf_range(1, 10)
		self.position.x = random+x
		random = rng.randf_range(1, 10)
		self.position.y = random+y
		type = 1
	elif(type == 1):
		random = rng.randf_range(1, 3)
		if(random == 1):
			self.texture = load("res://textures/fire/main/orange.png")
		elif(random == 2):
			self.texture = load("res://textures/fire/main/red.png")
		elif(random == 3):
			self.texture = load("res://textures/fire/main/yellow.png")
		self.visible = true
		type = 2
