extends Node2D
var touch = false
var jumpr = 0
var jump = 0
var fizyka = false
onready var last_time = OS.get_system_time_secs()
var type = false
var rotate2 = 1
onready var time = OS.get_system_time_msecs()
func _ready():
	jump = 1
	set_process(false)
	set_process_input(false)
	
func _process(delta):
	if(Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_SPACE)):
		fizyka = false
		jumpr = -0.5
		jump = 1
		fizyka = true
	if(OS.get_system_time_msecs() - time > 100):
		jumpr = jumpr+0.2
		time = OS.get_system_time_msecs()
	jump = jumpr+jump
	self.position.y += jump
	if(self.position.y >= 60):
		fizyka = false
		self.position.y = 60
	if(OS.get_system_time_secs() - last_time > 0.1):
		type = not type
		last_time = OS.get_system_time_secs()
	if(Input.is_key_pressed(KEY_D)):
		rotate2 = 1
		self.position.x += 0.8
	if(Input.is_key_pressed(KEY_A)):
		rotate2 = 2
		self.position.x -= 0.8
	if(rotate2 == 1):
		if(type == true and Input.is_key_pressed(KEY_D)):
			get_node("player/Sprite").texture = load("res://textures/player/right-1.png")
		if(type == false and Input.is_key_pressed(KEY_D)):
			get_node("player/Sprite").texture = load("res://textures/player/right-2.png")
	if(rotate2 == 2):
		if(type == true and Input.is_key_pressed(KEY_A)):
			get_node("player/Sprite").texture = load("res://textures/player/left-1.png")
		if(type == false and Input.is_key_pressed(KEY_A)):
			get_node("player/Sprite").texture = load("res://textures/player/left-2.png")
	



	
