extends Sprite

onready var last_time = OS.get_system_time_msecs()
var rotate2 = 1
var type = false


func _ready():
	set_process(true)
	set_process_input(true)

func _process(delta):
	if(Input.is_key_pressed(KEY_A)):
		rotate2 = 2
	if(Input.is_key_pressed(KEY_D)):
		rotate2 = 1
	if(OS.get_system_time_msecs() - last_time > 300):
		if(type == false):
			type = true
		elif(type == true):
			type = false
		last_time = OS.get_system_time_msecs()
	if(rotate2 == 1):
		if(type == true and Input.is_key_pressed(KEY_D)):
			self.texture = load("res://textures/player/right-1.png")
		if(type == false and Input.is_key_pressed(KEY_D)):
			self.texture = load("res://textures/player/right-2.png")
	if(rotate2 == 2):
		if(type == true and Input.is_key_pressed(KEY_A)):
			self.texture = load("res://textures/player/left-1.png")
		if(type == false and Input.is_key_pressed(KEY_A)):
			self.texture = load("res://textures/player/left-2.png")
