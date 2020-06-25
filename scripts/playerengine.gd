extends Node2D

onready var last_time = OS.get_system_time_secs()
var type = false
onready var time = OS.get_system_time_msecs()
const SPEED = 0.8
var GRAVITY = 1
const JUMP = -4
var rotate2 = 1
var g2 = 2
var ff = 0
var adder = 0
func _ready():
	set_process(false)
	set_process_input(false)
	

	
func _physics_process(delta):
	if(): #only information, is colliding
		if(Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_SPACE)):
			self.position.y += JUMP
			g2 = 1
			ff = 4
		if(g2 == 1):
			self.position.y += 1
		if(g2 == 2):
			self.position.y -= 1
		if(g2 == 3):
			self.position.x -= 1
		if(g2 == 4):
			self.position.x += 1
		
	if(self.position.y >= 60):
		GRAVITY = 0
	else:
		GRAVITY = 1
	self.position.y += GRAVITY
	ff -= 1
	if(ff <= 0):
		ff = 0
		g2 = 2
	if(Input.is_key_pressed(KEY_D)):
		rotate2 = 1
		self.position.x += SPEED
		g2 = 4
	if(Input.is_key_pressed(KEY_A)):
		rotate2 = 2
		self.position.x -= SPEED
		g2 = 3
	
	
func _process(delta):
	if(OS.get_system_time_secs() - last_time > 0.1):
		type = not type
		last_time = OS.get_system_time_secs()
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

	
