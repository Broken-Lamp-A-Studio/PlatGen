extends Node2D
onready var last_time = OS.get_system_time_secs()
var type = false
var rotate2 = 1

func _ready():
	set_process(true)
	set_process_input(true)
	

func _process(delta):
	if(OS.get_system_time_secs() - last_time > 0.1):
		type = not type
		last_time = OS.get_system_time_secs()
	if(Input.is_key_pressed(KEY_D)):
		rotate2 = 1
		self.position.x += 0.5
	if(Input.is_key_pressed(KEY_A)):
		rotate2 = 2
		self.position.x -= 0.5
		
	
	
	
	
	if(rotate2 == 1):
		if(type == true and Input.is_key_pressed(KEY_D)):
			get_node("Sprite").texture = load("res://textures/player/right-1.png")
		if(type == false and Input.is_key_pressed(KEY_D)):
			get_node("Sprite").texture = load("res://textures/player/right-2.png")
	if(rotate2 == 2):
		if(type == true and Input.is_key_pressed(KEY_A)):
			get_node("Sprite").texture = load("res://textures/player/left-1.png")
		if(type == false and Input.is_key_pressed(KEY_A)):
			get_node("Sprite").texture = load("res://textures/player/left-2.png")
