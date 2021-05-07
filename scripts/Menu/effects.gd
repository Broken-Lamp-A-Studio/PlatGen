extends Light2D

onready var time = OS.get_system_time_msecs()
var rng = RandomNumberGenerator.new()
func _ready():
	rng.randomize()
	self.energy = 1
func random_pos():
	var cx = get_tree().get_root().get_node("init/envoirment/Menu2/Camera2D").position.x
	var cy = get_tree().get_root().get_node("init/envoirment/Menu2/Camera2D").position.y
	var vx = get_viewport_rect().size.x/2
	var vy = get_viewport_rect().size.y/2
	position.x = rng.randf_range(-vx, vx)+cx
	position.y = rng.randf_range(-vy, vy)+cy
var type = 0
func _process(_delta):
	if(OS.get_system_time_msecs() - time > round(rng.randf_range(50, 500)) and type == 0):
		self.energy = 0
		self.visible = false
		random_pos()
		time = OS.get_system_time_msecs()
		type = 2
	elif(type == 1 and OS.get_system_time_msecs() - time > 100):
		self.visible = true
		self.energy += 0.05
		if(self.energy > 1):
			type = 4
		time = OS.get_system_time_msecs()
	elif(type == 2 and OS.get_system_time_msecs() - time > round(rng.randf_range(1000, 2000))):
		type = 1
		time = OS.get_system_time_msecs()
	elif(type == 4 and OS.get_system_time_msecs() - time > 100):
		self.visible = true
		self.energy -= 0.05
		if(self.energy <= 0):
			type = 0
		time = OS.get_system_time_msecs()
